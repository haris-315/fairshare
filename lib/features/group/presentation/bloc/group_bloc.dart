import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/group_repository.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/create_group.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroup createGroup;
  final AddExpense addExpense;
  // final UpdateGroup updateGroup;
  final GroupRepository repository;

  GroupBloc({
    required this.createGroup,
    required this.addExpense,
    // required this.updateGroup,
    required this.repository,
  }) : super(GroupInitial()) {
    on<CreateGroupEvent>((event, emit) async {
      emit(GroupLoading());
      final result = await createGroup(
        CreateGroupParams(
          name: event.name,
          members: event.members,
          userId: event.userId,
          groupIcon: event.groupIcon,
        ),
      );
      result.fold(
        (failure) => emit(GroupError(failure.message)),
        (_) => emit(GroupSuccess()),
      );
    });

    on<AddExpenseEvent>((event, emit) async {
      emit(GroupLoading());
      final result = await addExpense(
        AddExpenseParams(
          groupId: event.groupId,
          amount: event.amount,
          description: event.description,
          userId: event.userId,
        ),
      );
      result.fold(
        (failure) => emit(GroupError(failure.message)),
        (_) => emit(GroupSuccess()),
      );
    });

    // on<AddCommentEvent>((event, emit) async {
    //   emit(GroupLoading());
    //   final result = await repository.addComment(
    //     event.expenseId,
    //     event.content,
    //   );
    //   result.fold(
    //     (failure) => emit(GroupError(failure.message)),
    //     (_) => emit(GroupSuccess()),
    //   );
    // });

    // on<UpdateGroupEvent>((event, emit) async {
    //   emit(GroupLoading());
    //   final result = await updateGroup(
    //     UpdateGroupParams(groupId: event.groupId, newName: event.newName),
    //   );
    //   result.fold(
    //     (failure) => emit(GroupError(failure.message)),
    //     (_) => emit(GroupSuccess()),
    //   );
    // });

    // on<RemoveMemberEvent>((event, emit) async {
    //   emit(GroupLoading());
    //   final result = await repository.removeMember(event.groupId, event.userId);
    //   result.fold(
    //     (failure) => emit(GroupError(failure.message)),
    //     (_) => emit(GroupSuccess()),
    //   );
    // });

    on<LoadGroupsEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        final res = await repository.getUserGroups(event.userId);
        emit(GroupsLoaded(res));
      } catch (e) {
        emit(
          GroupError("There was an error while loading groups ${e.toString()}"),
        );
      }
    });

    on<LoadExpensesEvent>((event, emit) async {
      emit(GroupLoading());
      try {

      final res = await repository.getGroupExpenses(event.groupId);
      // emit(GroupsLoaded(res));

      } catch (e) {
        emit(
          GroupError("There was an error while loading groups ${e.toString()}"),
        );
      }

    });
  }
}
