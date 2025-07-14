// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class User {
  final String id;
  final String email;
  final String profile;
  final String name;
  User({
    required this.id,
    required this.email,
    required this.profile,
    required this.name,
  });

  factory User.fromSb(sb.User usr) => User(
    id: usr.id,
    email: usr.email ?? "",
    profile: usr.userMetadata?['profile_pic'] ?? "",
    name: usr.userMetadata?['name'] ?? ""
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'email': email, 'profile': profile};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      profile: map['profile_pic'] ?? "",
      name: map['name'] ?? ""
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
