
// import 'package:dartz/dartz.dart';
// import 'package:fairshare/core/error/failures.dart';
// import 'package:fairshare/core/usecases/usecase.dart';
// import '../repositories/group_repository.dart';

// class UpdateGroup implements UseCase<void, UpdateGroupParams> {
//   final GroupRepository repository;

//   UpdateGroup(this.repository);

//   @override
//   Future<Either<Failure, void>> call(UpdateGroupParams params) async {
//     return await repository.updateGroup(params.groupId, params.newName);
//   }
// }

// class UpdateGroupParams {
//   final String groupId;
//   final String newName;

//   UpdateGroupParams({required this.groupId, required this.newName});
// }