
import '../../domain/entities/group.dart';

class GroupModel extends Group {
  GroupModel({
    required String id,
    required String name,
    required String adminId,
    required List<String> memberIds,
  }) : super(id: id, name: name, adminId: adminId, memberIds: memberIds);

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      adminId: json['admin_id'],
      memberIds: List<String>.from(json['member_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'admin_id': adminId,
        'member_ids': memberIds,
      };
}