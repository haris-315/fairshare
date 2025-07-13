
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:fairshare/core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
    Future<Either<Failure, User>> call(SignInParams params) async {
      // The .fold method is used on an existing Either to handle its Left and Right cases.
      // It is not used to convert a potentially throwing function into an Either.
      // The current implementation using try-catch is the standard way to convert
      // a Future that might throw exceptions into a Future<Either<Failure, T>>.
      // Therefore, the existing code is already the correct approach for this scenario.

      try {
        final user = await repository.signIn(params.email, params.password);
        return Right(user);
      } catch (e) {
        // Map the exception 'e' to a Failure.
        // Assuming ServerFailure is a valid Failure type defined in failures.dart
        return Left(ServerFailure(e.toString()));
      }
    }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}