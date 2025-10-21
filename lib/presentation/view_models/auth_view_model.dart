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
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends BaseViewModel {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final AuthRepository _authRepository;
  final UpdatePasswordUseCase _updatePasswordUseCase;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(
   {
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required AuthRepository authRepository,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
        _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
        _updatePasswordUseCase = updatePasswordUseCase,
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
          _setError("Bạn không có quyền truy cập Admin");
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

  Future<bool> register(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _registerUseCase(email, password);

      if (result.isSuccess) {
        _currentUser = result.user;
        _setLoading(false);
        return true;
      } else {
        _setLoading(false);
        _setError(result.errorMessage ?? AppStrings.signUpFailed);
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
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _resetPasswordUseCase(email);

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setLoading(false);
        _setError(result.errorMessage ?? AppStrings.sendEmailFailed);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(AppStrings.unknownError);
      return false;
    }
  }
  Future<bool> sendEmailVerification(String email, String otpCode) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _sendEmailVerificationUseCase(email, otpCode);

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setLoading(false);
        _setError(result.errorMessage ?? AppStrings.sendVerificationFailed);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(AppStrings.unknownError);
      return false;
    }
  }
  Future<bool> updatePassword(String newPassword) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _updatePasswordUseCase(newPassword);

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setLoading(false);
        _setError(result.errorMessage ?? AppStrings.updatePasswordFailed);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(AppStrings.unknownError);
      return false;
    }
  }

  List<ProfileModel> userList = [];

  Future<void> fetchUsers() async {
    try {
      _setLoading(true);
      userList = await _authRepository.getAllProfiles();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError("Lỗi khi lấy user: $e");
    }
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
      _setError("Lỗi khi xóa user: $e");
      print("Lỗi khi xóa user: $e");
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
  void clearError() {
    _clearError();
  }
}
