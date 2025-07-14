
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email, required super.profile});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'],profile: json['profile_pic']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}