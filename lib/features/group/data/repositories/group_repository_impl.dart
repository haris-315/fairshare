
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_data_source.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Group>>> createGroup({required String name, required String userId, required List<String> members, required XFile groupIcon}) async {
    try {
      final group = await remoteDataSource.createGroup(name: name, userId: userId, members: members, groupIcon: groupIcon);
      return Right(group);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addExpense(String groupId, String userId, double amount, String description) async {
    try {
      await remoteDataSource.addExpense(groupId, userId, amount,description);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, void>> addComment(String expenseId, String content) async {
  //   try {
  //     await remoteDataSource.addComment(expenseId, content);
  //     return Right(null);
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> updateGroup(String groupId, String newName) async {
  //   try {
  //     await remoteDataSource.updateGroup(groupId, newName);
  //     return Right(null);
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> removeMember(String groupId, String userId) async {
  //   try {
  //     await remoteDataSource.removeMember(groupId, userId);
  //     return Right(null);
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  @override
  Future<List<Group>> getUserGroups(String userId) async {
    return await remoteDataSource.getGroups(userId);
  }

  @override
  Future<List<Expense>> getGroupExpenses(String groupId) async {
    return await remoteDataSource.getExpenseForGroup(groupId);
  }
}