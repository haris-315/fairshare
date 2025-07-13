abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpEvent({required this.email, required this.password});
}

class VerifyOTPEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyOTPEvent({required this.email, required this.otp});
}