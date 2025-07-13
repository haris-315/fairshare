class Group {
  final String id;
  final String name;
  final String groupIcon;
  final String adminId;
  final List<String> memberIds;

  Group({
    required this.id,
    required this.name,
    required this.adminId,
    required this.memberIds,
    required this.groupIcon
  });
}
