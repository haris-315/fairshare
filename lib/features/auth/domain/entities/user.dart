import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class User {
  final String id;
  final String email;
  final String profile;
  User({required this.id, required this.email, required this.profile});

  factory User.fromSb(sb.User usr) => User(
    id: usr.id,
    email: usr.email ?? "",
    profile: usr.userMetadata?['profile_pic'] ?? "",
  );
}
