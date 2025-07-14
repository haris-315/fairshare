
import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    required super.id,
    required super.groupId,
    required super.userId,
    required super.amount,
    required super.description,
    required super.createdAt,
    required List<CommentModel> super.comments,
  });

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
    required super.id,
    required super.userId,
    required super.content,
    required super.createdAt,
  });

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