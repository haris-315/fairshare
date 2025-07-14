// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String profilePic;
  SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.profilePic,
  });
}

class CheckUserEvent extends AuthEvent {
  final String email;

  CheckUserEvent({required this.email});
}

class VerifyOTPEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyOTPEvent({required this.email, required this.otp});
}
