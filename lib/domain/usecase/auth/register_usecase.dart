import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/entities/auth_result.dart';
import 'package:admin_event_go/domain/utils/auth_error_handler.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<AuthResult> call(String email, String password) async {
    try {
      final user = await _authRepository.createUserWithEmailAndPassword(email, password);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(AuthErrorHandler.getErrorMessage(e));
    }
  }
}