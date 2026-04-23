import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/entities/auth_result.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<AuthResult> call() async {
    try {
      await _authRepository.signOut();
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(AppStrings.logoutErrorWithDetails + e.toString());
    }
  }
}
