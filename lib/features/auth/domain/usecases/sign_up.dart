import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:fairshare/core/usecases/usecase.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    try {
      final user = await repository.signUp(params.email, params.password);
      return Right(user);
    } catch (e) {
      // In a real application, you would handle different types of exceptions
      // and map them to appropriate Failure types (e.g., AuthFailure, NetworkFailure).
      // For this example, we'll return a generic ServerFailure.
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SignUpParams {
  final String email;
  final String password;

  SignUpParams({required this.email, required this.password});
}
