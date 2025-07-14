
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:fairshare/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckUser implements UseCase<bool, String> {
  final AuthRepository repository;

  CheckUser(this.repository);

  @override
    Future<Either<Failure, bool>> call(String email) async {
     

      try {
        final res = await repository.checkUser(email);
        return Right(res);
      } catch (e) {
       
        return Left(ServerFailure(e.toString()));
      }
    }
}

class CheckUserParams {
  final String email;
  final String password;

  CheckUserParams({required this.email, required this.password});
}