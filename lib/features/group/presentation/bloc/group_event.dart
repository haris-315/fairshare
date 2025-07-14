
import 'package:image_picker/image_picker.dart';

abstract class GroupEvent {}

class CreateGroupEvent extends GroupEvent {
  final String name;
  final List<String> members;
  final String userId;
  final XFile groupIcon;

  CreateGroupEvent({
    required this.name,
    required this.members,
    required this.userId,
    required this.groupIcon,
  });
}

class AddExpenseEvent extends GroupEvent {
  final String groupId;
  final double amount;
  final String description;
  final String userId;

  AddExpenseEvent({
    required this.groupId,
    required this.amount,
    required this.description,
    required this.userId
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
