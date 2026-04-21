import 'dart:async';

import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/profile_model.dart';
import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/usecase/auth/login_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/logout_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/register_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/reset_password_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/send_email_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/update_password_use_case.dart';
import 'package:admin_event_go/presentation/view_models/dashboad_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends BaseViewModel {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;
  final DashboadViewModel dashboardViewModel;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this.dashboardViewModel,
   {
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required AuthRepository authRepository,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _authRepository = authRepository {
    _authRepository.authStateChanges.listen((authState) {
      _currentUser = authState.session?.user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _authRepository.isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      final result = await _loginUseCase(email, password);
      if (result.isSuccess) {
        final profile = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', result.user!.id)
            .single();

        if (profile['role'] == 'admin') {
          _currentUser = result.user;
          _setLoading(false);
          return true;
        } else {
          await logout();
          _setError(AppStrings.noAdminAccess);
          return false;
        }
      } else {
        _setLoading(false);
        _setError(result.errorMessage ?? AppStrings.loginFailed);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(AppStrings.unknownError);
      return false;
    }
  }
  Future<void> logout() async {
    try {
      final result = await _logoutUseCase();
      if (result.isSuccess) {
        _currentUser = null;
        notifyListeners();
      } else {
        _setError(result.errorMessage ?? AppStrings.logoutFailed);
      }
    } catch (e) {
      _setError(AppStrings.logoutError);
    }
  }

  List<ProfileModel> get userList => dashboardViewModel.users;
  List<ProfileModel> get staffList => dashboardViewModel.staff;

  Future<void> fetchUsers() async {
   dashboardViewModel.fetchUsers();
  } Future<void> fetchStaff() async {
  await dashboardViewModel.fetchStaff();
  notifyListeners();
  }
  Future<bool> deleteUser(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      await Supabase.instance.client
          .from('profiles')
          .delete()
          .eq('id', userId);
  await Supabase.instance.client
          .rpc('delete_auth_user', params: {'user_id': userId});
      await fetchUsers();
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError("${AppStrings.deleteUsersErrorWithDetails}$e");
      print("Lỗi khi xóa users: $e");
      return false;
    }
  }
  Future<bool> deleteStaff(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      await Supabase.instance.client
          .from('profiles')
          .delete()
          .eq('id', userId);
      await Supabase.instance.client
          .rpc('delete_auth_user', params: {'user_id': userId});
      await fetchStaff();
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError("${AppStrings.deleteUsersErrorWithDetails}$e");
      print("Lỗi khi xóa users: $e");
      return false;
    }
  }
  Future<void> refreshProfiles() async {
    try {
      fetchUsers();
    } catch (e) {
      print("Error refreshing profiles: $e");
    }
  }
  Future<bool> createStaff({
    required String fullName,
    required String email,
    required String phone,
    required String role,
    String? avatarUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: "123456789",
      );
      if (res.user == null) {
        _setError(AppStrings.createStaffFailed);
        _setLoading(false);
        return false;
      }

      final uid = res.user!.id;

      await Supabase.instance.client.from('profiles').insert({
        'id': uid,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'avatar_url': avatarUrl ?? "",
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      });

      await fetchStaff();
      _setLoading(false);
      return true;

    } catch (e) {
      _setLoading(false);
      _setError("${AppStrings.createStaffErrorWithDetails}$e");
      return false;
    }
  }

  Future<bool> updateStaff({
    required String id,
    required String fullName,
    required String email,
    required String phone,
    required String role,
    String? avatarUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await Supabase.instance.client.from('profiles').update({
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'avatar_url': avatarUrl ?? "",
        'role': role,
      }).eq('id', id);

      await fetchStaff();
      _setLoading(false);
      return true;
    } catch (e, s) {
      _setError("${AppStrings.createStaffErrorWithDetails}$e");
      _setLoading(false);
      return false;
    }
  }
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

}
