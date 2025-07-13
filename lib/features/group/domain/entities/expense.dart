
class Expense {
  final String id;
  final String groupId;
  final String userId;
  final double amount;
  final String description;
  final DateTime createdAt;
  final List<Comment> comments;

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.comments,
  });
}

class Comment {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
}