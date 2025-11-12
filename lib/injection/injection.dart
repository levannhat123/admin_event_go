import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/data/repositories/auth_repository_impl.dart';
import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/repositories/event/event_repository_impl.dart';
import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/repositories/category/category_repository_impl.dart';
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
import 'package:admin_event_go/domain/usecase/event/watch_all_events_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/add_category_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/update_category_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/delete_category_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/get_category_by_id_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/get_all_categories_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/watch_all_categories_usecase.dart';
import 'package:admin_event_go/presentation/view_models/auth_change_notifier.dart';
import 'package:admin_event_go/presentation/view_models/auth_view_model.dart';
import 'package:admin_event_go/presentation/view_models/dashboad_view_model.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/presentation/view_models/category_view_model.dart';
import 'package:admin_event_go/data/services/supabase_storage_service.dart';
import 'package:admin_event_go/presentation/view_models/order_view_model.dart';
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
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());

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
  getIt.registerLazySingleton(() => WatchAllEventsUsecase(getIt<EventRepository>()));

  // Category UseCases
  getIt.registerLazySingleton(() => AddCategoryUsecase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(() => UpdateCategoryUsecase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(() => DeleteCategoryUsecase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(() => GetCategoryByIdUsecase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(() => GetAllCategoriesUsecase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(() => WatchAllCategoriesUsecase(getIt<CategoryRepository>()));

  // ViewModels
  getIt.registerFactory(
    () => AuthViewModel(
      getIt<DashboadViewModel>(),
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      authRepository: getIt<AuthRepository>(),
      sendEmailVerificationUseCase: getIt<SendEmailVerificationUseCase>(),
      updatePasswordUseCase: getIt<UpdatePasswordUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => EventViewModel(
      getIt<DashboadViewModel>(),
      addEventUsecase: getIt<AddEventUsecase>(),
      updateEventUsecase: getIt<UpdateEventUsecase>(),
      deleteEventUsecase: getIt<DeleteEventUsecase>(),
      getEventByIdUsecase: getIt<GetEventByIdUsecase>(),
      getAllEventsUsecase: getIt<GetAllEventsUsecase>(),
      watchAllEventsUsecase: getIt<WatchAllEventsUsecase>(),
    ),
  );

  getIt.registerFactory(
    () => CategoryViewModel(
      addCategoryUsecase: getIt<AddCategoryUsecase>(),
      updateCategoryUsecase: getIt<UpdateCategoryUsecase>(),
      deleteCategoryUsecase: getIt<DeleteCategoryUsecase>(),
      getCategoryByIdUsecase: getIt<GetCategoryByIdUsecase>(),
      getAllCategoriesUsecase: getIt<GetAllCategoriesUsecase>(),
      watchAllCategoriesUsecase: getIt<WatchAllCategoriesUsecase>(),
    ),
  );
  getIt.registerSingleton(
    DashboadViewModel(getIt<WatchAllEventsUsecase>(), getIt<AuthRepository>()),
  );
  getIt.registerSingleton(OrderViewModel());
}
