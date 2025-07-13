
import 'package:dartz/dartz.dart';
import 'package:fairshare/core/error/failures.dart';
import 'package:fairshare/core/usecases/usecase.dart';
import '../repositories/group_repository.dart';

class AddExpense implements UseCase<void, AddExpenseParams> {
  final GroupRepository repository;

  AddExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(AddExpenseParams params) async {
    return await repository.addExpense(params.groupId, params.amount, params.description);
  }
}

class AddExpenseParams {
  final String groupId;
  final double amount;
  final String description;

  AddExpenseParams({required this.groupId, required this.amount, required this.description});
}