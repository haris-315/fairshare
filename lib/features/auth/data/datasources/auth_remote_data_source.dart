import 'package:fairshare/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

abstract class AuthRemoteDataSource {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String name, String profilePic);
  Future<User> verifyOTP(String email, String otp);
  Future<bool> checkUser(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase = sb.Supabase.instance.client;

  @override
  Future<User> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Sign in failed');
    }
    return User.fromSb(response.user!);
  }

  @override
  Future<User> signUp(String userId, String name, String profilePic) async {
    final res =
        await supabase.from("profiles").insert({
          'name': name,
          'profile_pic': profilePic,
        }).select();

    return User.fromMap(res);
  }

  @override
  Future<User> verifyOTP(String email, String otp) async {
    final response = await supabase.auth.verifyOTP(
      token: otp,
      type: sb.OtpType.signup,
      email: email,
    );

    if (response.user == null) {
      throw Exception('OTP verification failed');
    }

    return User.fromSb(response.user!);
  }

  @override
  Future<bool> checkUser(String email) async {
    final res =
        await supabase
            .from('profiles')
            .select()
            .eq('email', email)
            .maybeSingle();
    supabase.auth.signInWithOtp(email: email);
    return res != null;
  }
}
