import 'package:admin_event_go/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Stream<AuthState> get authStateChanges;
  User? get currentUser;
  bool get isLoggedIn;

  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<List<ProfileModel>> getAllProfiles();
  Future<List<ProfileModel>> getAllStaff();
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> deleteAccount();
  Future<User?> updatePassword(String newPassword);
  Future<void> sendEmailVerification(String email, String otpCode);
}
