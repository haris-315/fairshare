import 'package:fairshare/features/auth/domain/entities/user.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signIn(String email, String password) async {
    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<User> signUp(String email,  String name, String profilePic) async {
    return await remoteDataSource.signUp(email,  name, profilePic);
  }

  @override
  Future<User> verifyOTP(String email, String otp) async {
    return await remoteDataSource.verifyOTP(email, otp);
  }
  
  @override
  Future<bool> checkUser(String email) async {
    return await remoteDataSource.checkUser(email);
    }
}