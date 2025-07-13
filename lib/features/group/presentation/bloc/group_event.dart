import 'dart:io';

abstract class GroupEvent {}

class CreateGroupEvent extends GroupEvent {
  final String name;
  final List<String> memberEmails;
  final String userId;
  final File groupIcon;
  CreateGroupEvent({
    required this.name,
    required this.memberEmails,
    required this.userId,
    required this.groupIcon
  });
}

class AddExpenseEvent extends GroupEvent {
  final String groupId;
  final double amount;
  final String description;

  AddExpenseEvent({
    required this.groupId,
    required this.amount,
    required this.description,
  });
}

class AddCommentEvent extends GroupEvent {
  final String expenseId;
  final String content;

  AddCommentEvent({required this.expenseId, required this.content});
}

class UpdateGroupEvent extends GroupEvent {
  final String groupId;
  final String newName;

  UpdateGroupEvent({required this.groupId, required this.newName});
}

class RemoveMemberEvent extends GroupEvent {
  final String groupId;
  final String userId;

  RemoveMemberEvent({required this.groupId, required this.userId});
}

class LoadGroupsEvent extends GroupEvent {
  final String userId;

  LoadGroupsEvent({required this.userId});
}

class LoadExpensesEvent extends GroupEvent {
  final String groupId;

  LoadExpensesEvent({required this.groupId});
}
