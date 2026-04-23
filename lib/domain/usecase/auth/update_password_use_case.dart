import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/entities/auth_result.dart';
import 'package:admin_event_go/domain/utils/auth_error_handler.dart';

class UpdatePasswordUseCase {
  final AuthRepository _authRepository;

  UpdatePasswordUseCase(this._authRepository);

  Future<AuthResult> call(String newPassword) async {
    try {
      final user = await _authRepository.updatePassword(newPassword);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(AuthErrorHandler.getErrorMessage(e));
    }
  }
}