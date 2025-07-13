
import '../../domain/entities/group.dart';
import '../../domain/entities/expense.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<Group> groups;

  GroupsLoaded(this.groups);
}

class ExpensesLoaded extends GroupState {
  final List<Expense> expenses;

  ExpensesLoaded(this.expenses);
}

class GroupSuccess extends GroupState {}

class GroupError extends GroupState {
  final String message;

  GroupError(this.message);
}