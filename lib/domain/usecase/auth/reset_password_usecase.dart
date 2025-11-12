import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/entities/auth_result.dart';
import 'package:admin_event_go/domain/utils/auth_error_handler.dart';

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);

  Future<AuthResult> call(String email) async {
    try {
      await _authRepository.resetPassword(email);
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(AuthErrorHandler.getErrorMessage(e));
    }
  }
}