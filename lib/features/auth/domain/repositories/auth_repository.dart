
import 'package:fairshare/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<User> verifyOTP(String email, String otp);
}