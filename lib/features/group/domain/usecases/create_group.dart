
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:fairshare/core/usecases/usecase.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/group.dart';
import '../repositories/group_repository.dart';

class CreateGroup implements UseCase<List<Group>, CreateGroupParams> {
  final GroupRepository repository;

  CreateGroup(this.repository);

  @override
  Future<Either<Failure, List<Group>>> call(CreateGroupParams params) async {
    return await repository.createGroup(name: params.name, userId: params.userId, members: params.members, groupIcon: params.groupIcon);
  }
}

class CreateGroupParams {
  final String name;
  final String userId;
  final List<String> members;
  final XFile groupIcon;
  CreateGroupParams({required this.name, required this.members, required this.userId,required this.groupIcon});
}