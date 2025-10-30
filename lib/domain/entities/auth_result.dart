import 'package:supabase_flutter/supabase_flutter.dart';
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  AuthResult._({required this.isSuccess, this.user, this.errorMessage});

  factory AuthResult.success(User? user) => AuthResult._(isSuccess: true, user: user);
  factory AuthResult.failure(String errorMessage) => AuthResult._(isSuccess: false, errorMessage: errorMessage);
}
