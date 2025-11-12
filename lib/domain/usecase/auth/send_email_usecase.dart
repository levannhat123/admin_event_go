import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/entities/auth_result.dart';
import 'package:admin_event_go/domain/utils/auth_error_handler.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;

  SendEmailVerificationUseCase(this._authRepository);

  Future<AuthResult> call(String email, String otpCode) async {
    try {
      await _authRepository.sendEmailVerification(email, otpCode);
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(AuthErrorHandler.getErrorMessage(e));
    }
  }
}