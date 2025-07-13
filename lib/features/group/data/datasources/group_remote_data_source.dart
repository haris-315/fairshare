import 'dart:convert';

import 'package:fairshare/core/services/cloudinary_service.dart';
import 'package:fairshare/features/group/data/models/expense_model.dart';
import 'package:fairshare/features/group/data/models/group_model.dart';
import 'package:fairshare/features/group/domain/entities/expense.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/group.dart';

abstract class GroupRemoteDataSource {
  Future<List<Group>> createGroup({required String name, required String userId, required List<String> members, required XFile groupIcon});
  Future<List<Group>> getGroups(String userId);
  Future<void> addMember(String groupId, String userId);
  Future<void> addExpense(String groupId, String userId, double amount, String description);
  Future<List<Expense>> getExpenseForGroup(String groupId);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Group>> createGroup({required String name, required String userId, required List<String> members, required XFile groupIcon}) async {
    try {
      String iconUrl = await CloudinaryService.uploadImage(groupIcon.path);
      await supabase.from('groups').insert({
        'name': name,
        'admin_id': userId,
        'members' : jsonEncode(members),
        'group_icon' : iconUrl
      }).select().single();
      await supabase.functions.invoke('send-fcm-notification', body: {
        'user_id': userId,
        'message': 'You have created a new group $name',
      });
      final response = await supabase
          .from('groups')
          .select('id, name, admin_id, created_at, group_members!inner(user_id)')
          .eq('group_members.user_id', userId);
      return response.map((group) => GroupModel.fromJson(group)).toList();
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  @override
  Future<List<Group>> getGroups(String userId) async {
    try {
      final response = await supabase
          .from('groups')
          .select('id, name, admin_id, created_at, group_members!inner(user_id)')
          .eq('group_members.user_id', userId);
      return response.map((group) => GroupModel.fromJson(group)).toList();
    } catch (e) {
      throw Exception('Failed to fetch groups: $e');
    }
  }

  

  @override
  Future<void> addMember(String groupId, String userId) async {
    try {
      // Validate user exists
      final userExists = await supabase
          .from('auth.users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      if (userExists == null) {
        throw Exception('User $userId does not exist');
      }
      await supabase.from('groups').select("members").eq('group_id', groupId);
      final groupName = await supabase
          .from('groups')
          .select('name')
          .eq('id', groupId)
          .single();
      await supabase.functions.invoke('send-fcm-notification', body: {
        'user_id': userId,
        'message': 'You were added to group: ${groupName['name']}',
      });
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  @override
  Future<void> addExpense(String groupId, String userId, double amount, String description) async {
    try {
      await supabase.from('expenses').insert({
        'group_id': groupId,
        'user_id': userId,
        'amount': amount,
        'description': description,
      });
      final groupName = await supabase
          .from('groups')
          .select('name')
          .eq('id', groupId)
          .single();
      await supabase.functions.invoke('send-fcm-notification', body: {
        'user_id': userId,
        'message': 'You added an expense to group: ${groupName['name']}',
      });
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }
  
  @override
  Future<List<Expense>> getExpenseForGroup(String groupId) async {
    try {
      var expenses = await supabase.from('expenses').select().eq("group_id", groupId);
      return (expenses as List).map((expns) => ExpenseModel.fromJson(expns)).toList();
      
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }
}