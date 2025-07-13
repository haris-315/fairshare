
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:fairshare/core/usecases/usecase.dart';
import '../entities/group.dart';
import '../repositories/group_repository.dart';

class CreateGroup implements UseCase<Group, CreateGroupParams> {
  final GroupRepository repository;

  CreateGroup(this.repository);

  @override
  Future<Either<Failure, Group>> call(CreateGroupParams params) async {
    return await repository.createGroup(params.name, params.memberEmails);
  }
}

class CreateGroupParams {
  final String name;
  final List<String> memberEmails;

  CreateGroupParams({required this.name, required this.memberEmails});
}