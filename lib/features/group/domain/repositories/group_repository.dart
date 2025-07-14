
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/group.dart';
import '../entities/expense.dart';

abstract class GroupRepository {
  Future<Either<Failure, List<Group>>> createGroup({required String name, required String userId, required List<String> members, required XFile groupIcon});
  Future<Either<Failure, void>> addExpense(String groupId, String userId, double amount, String description);
  // Future<Either<Failure, void>> addComment(String expenseId, String content);
  // Future<Either<Failure, void>> updateGroup(String groupId, String newName);
  // Future<Either<Failure, void>> removeMember(String groupId, String userId);
  Future<List<Group>> getUserGroups(String userId);
  Future<List<Expense>> getGroupExpenses(String groupId);
}