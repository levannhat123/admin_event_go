import 'dart:async';

import 'package:admin_event_go/core/config/supabase_config.dart';
import 'package:admin_event_go/firebase_options.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/auth_change_notifier.dart';
import 'package:admin_event_go/routers/app_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_colors.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );

    final appRouter = AppRouter(AuthChangeNotifier());

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    setupDependencies(appRouter.router);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthChangeNotifier())
        ],
        child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MyApp(router: appRouter.router);
          },
        ),
      ),
    );
  }, (error, stack) {
    debugPrint('Error: $error');
    debugPrint('Stack: $stack');
  });
}


class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'IBMPlexSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.background,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
