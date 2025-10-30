import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Helper class để xử lý lỗi từ Supabase trong UseCase layer
class AuthErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return _mapAuthException(error.message);
    } else {
      return AppStrings.unknownErrorWithDetails + error.toString();
    }
  }

  static String _mapAuthException(String errorMessage) {
    final lowerCaseError = errorMessage.toLowerCase();

    if (lowerCaseError.contains('invalid login credentials')) {
      return AppStrings.wrongEmailOrPassword;
    } else if (lowerCaseError.contains('email not confirmed')) {
      return AppStrings.pleaseVerifyEmail;
    } else if (lowerCaseError.contains('email already registered')) {
      return AppStrings.emailAlreadyRegistered;
    } else if (lowerCaseError.contains('password should be at least')) {
      return AppStrings.passwordTooShort;
    } else if (lowerCaseError.contains('invalid email')) {
      return AppStrings.invalidEmail;
    } else if (lowerCaseError.contains('users not found')) {
      return AppStrings.accountNotFound;
    } else if (lowerCaseError.contains('too many requests')) {
      return AppStrings.tooManyRequests;
    } else {
      return AppStrings.errorOccurred + errorMessage;
    }
  }
}
