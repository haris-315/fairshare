
import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    required String id,
    required String groupId,
    required String userId,
    required double amount,
    required String description,
    required DateTime createdAt,
    required List<CommentModel> comments,
  }) : super(
          id: id,
          groupId: groupId,
          userId: userId,
          amount: amount,
          description: description,
          createdAt: createdAt,
          comments: comments,
        );

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      groupId: json['group_id'],
      userId: json['user_id'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((c) => CommentModel.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'user_id': userId,
        'amount': amount,
        'description': description,
        'created_at': createdAt.toIso8601String(),
        'comments': comments.map((c) => (c as CommentModel).toJson()).toList(),
      };
}

class CommentModel extends Comment {
  CommentModel({
    required String id,
    required String userId,
    required String content,
    required DateTime createdAt,
  }) : super(id: id, userId: userId, content: content, createdAt: createdAt);

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };
}