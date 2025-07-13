import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:fairshare/core/services/cloudinary_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isSignUp = false;
  bool _isAwaitingOTP = false;
  String? _profilePictureUrl;
  final _cloudinaryService = CloudinaryService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final url = await _cloudinaryService.uploadImage(pickedFile.path);
      setState(() => _profilePictureUrl = url);
    }
  }

  Future<void> _saveDeviceToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await sb.Supabase.instance.client.from('device_tokens').insert({
        'user_id': userId,
        'device_token': token,
      });
    }
  }

  Future<void> _saveUsername(String userId) async {
    if (_isSignUp && _usernameController.text.isNotEmpty) {
      await sb.Supabase.instance.client.from('users').insert({
        'id': userId,
        'username': _usernameController.text,
        'profile_picture': _profilePictureUrl,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthAuthenticated) {
                    await _saveDeviceToken(state.user.id);
                    await _saveUsername(state.user.id);
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (state is AuthAwaitingOTP) {
                    setState(() => _isAwaitingOTP = true);
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isSignUp
                          ? (_isAwaitingOTP ? 'Verify OTP' : 'Sign Up')
                          : 'Sign In',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (_isSignUp && !_isAwaitingOTP)
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              _profilePictureUrl != null
                                  ? NetworkImage(_profilePictureUrl!)
                                  : null,
                          child:
                              _profilePictureUrl == null
                                  ? const Icon(Icons.camera_alt, size: 40)
                                  : null,
                        ),
                      ),
                    if (_isSignUp && !_isAwaitingOTP)
                      const SizedBox(height: 16),
                    if (_isSignUp && !_isAwaitingOTP)
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    if (_isSignUp && !_isAwaitingOTP)
                      const SizedBox(height: 16),
                    if (!_isAwaitingOTP)
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    if (!_isAwaitingOTP) const SizedBox(height: 16),
                    if (!_isAwaitingOTP)
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        obscureText: true,
                      ),
                    if (_isSignUp && _isAwaitingOTP)
                      TextField(
                        controller: _otpController,
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          prefixIcon: Icon(Icons.vpn_key),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      onPressed: () {
                        if (_isSignUp && _isAwaitingOTP) {
                          context.read<AuthBloc>().add(
                            VerifyOTPEvent(
                              email: _emailController.text,
                              otp: _otpController.text,
                            ),
                          );
                        } else if (_isSignUp) {
                          context.read<AuthBloc>().add(
                            SignUpEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        } else {
                          context.read<AuthBloc>().add(
                            SignInEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      },
                      child: Text(
                        _isSignUp && _isAwaitingOTP
                            ? 'Verify OTP'
                            : (_isSignUp ? 'Sign Up' : 'Sign In'),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => setState(() {
                            _isSignUp = !_isSignUp;
                            _isAwaitingOTP = false;
                            _otpController.clear();
                          }),
                      child: Text(
                        _isSignUp ? 'Switch to Sign In' : 'Switch to Sign Up',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
