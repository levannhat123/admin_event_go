import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? currentUser;

  AuthChangeNotifier() {
    _supabase.auth.onAuthStateChange.listen((data) {
      currentUser = data.session?.user;
      notifyListeners();
    });
    currentUser = _supabase.auth.currentUser;
  }

  bool get isLoggedIn => currentUser != null;
}
