import '../../domain/entities/group.dart';

class GroupModel extends Group {
  GroupModel({
    required super.id,
    required super.name,
    required super.adminId,
    required super.memberIds,
    required super.groupIcon,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      adminId: json['admin_id'],
      memberIds: List<String>.from(json['member_ids'] ?? []),
      groupIcon: json['groupIcon'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'admin_id': adminId,
    'member_ids': memberIds,
  };
}
