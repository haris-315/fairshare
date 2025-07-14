// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      final user = await repository.signUp(params.email,params.name, params.profilePic);
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
  final String name;
  final String profilePic;
  SignUpParams({
    required this.email,
    required this.name,
    required this.profilePic,
  });
}
