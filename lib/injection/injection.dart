import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/data/repositories/auth_repository_impl.dart';
import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/repositories/event/event_repository_impl.dart';
import 'package:admin_event_go/domain/usecase/auth/login_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/logout_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/register_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/reset_password_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/send_email_usecase.dart';
import 'package:admin_event_go/domain/usecase/auth/update_password_use_case.dart';
import 'package:admin_event_go/domain/usecase/event/add_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/update_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/delete_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/get_event_by_id_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/get_all_events_usecase.dart';
import 'package:admin_event_go/presentation/view_models/auth_change_notifier.dart';
import 'package:admin_event_go/presentation/view_models/auth_view_model.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/data/services/supabase_storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final getIt = GetIt.instance;

void setupDependencies(GoRouter router) {
  // Services
  getIt.registerLazySingleton(() => SupabaseStorageService());

  // Repositories
  getIt.registerSingleton<AuthChangeNotifier>(AuthChangeNotifier());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<EventRepository>(() => EventRepositoryImpl());

  // Auth UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SendEmailVerificationUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => UpdatePasswordUseCase(getIt<AuthRepository>()));

  // Event UseCases
  getIt.registerLazySingleton(() => AddEventUsecase(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => UpdateEventUsecase(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => DeleteEventUsecase(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => GetEventByIdUsecase(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => GetAllEventsUsecase(getIt<EventRepository>()));

  // ViewModels
  getIt.registerFactory(() => AuthViewModel(
    loginUseCase: getIt<LoginUseCase>(),
    registerUseCase: getIt<RegisterUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    authRepository: getIt<AuthRepository>(),
    sendEmailVerificationUseCase: getIt<SendEmailVerificationUseCase>(),
    updatePasswordUseCase: getIt<UpdatePasswordUseCase>(),
  ));

  getIt.registerFactory(() => EventViewModel(
    addEventUsecase: getIt<AddEventUsecase>(),
    updateEventUsecase: getIt<UpdateEventUsecase>(),
    deleteEventUsecase: getIt<DeleteEventUsecase>(),
    getEventByIdUsecase: getIt<GetEventByIdUsecase>(),
    getAllEventsUsecase: getIt<GetAllEventsUsecase>(),
  ));
}