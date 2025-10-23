
import 'package:admin_event_go/presentation/pages/auth/forgot_password_screen.dart';
import 'package:admin_event_go/presentation/pages/auth/login_screen.dart';
import 'package:admin_event_go/presentation/pages/auth/new_password_screen.dart';
import 'package:admin_event_go/presentation/pages/auth/otp_verification_screen.dart';
import 'package:admin_event_go/presentation/pages/auth/sign_up_screen.dart';
import 'package:admin_event_go/presentation/pages/dashboad/dashboard_screen.dart';
import 'package:admin_event_go/presentation/pages/dashboard_page.dart';
import 'package:admin_event_go/presentation/pages/events_page.dart';
import 'package:admin_event_go/presentation/pages/events/events_list_page.dart';
import 'package:admin_event_go/presentation/pages/events/add_event_page.dart';
import 'package:admin_event_go/presentation/pages/events/event_details_page.dart';
import 'package:admin_event_go/presentation/pages/events/categories_page.dart';
import 'package:admin_event_go/presentation/pages/events/ticket_types_page.dart';
import 'package:admin_event_go/presentation/pages/langding/langding_screen.dart';
import 'package:admin_event_go/presentation/pages/main/main_screen.dart';
import 'package:admin_event_go/presentation/pages/orders_page.dart';
import 'package:admin_event_go/presentation/pages/settings_page.dart';
import 'package:admin_event_go/presentation/pages/users_page.dart';
import 'package:admin_event_go/presentation/view_models/auth_change_notifier.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter router;
  AppRouter(AuthChangeNotifier authNotifier)
    : router = GoRouter(
        initialLocation: RouterPath.dashboard,
        debugLogDiagnostics: true,
        routes: [
          GoRoute(path: RouterPath.login, builder: (context, state) => LoginScreen()),
          GoRoute(path: RouterPath.sign_up, builder: (context, state) => SignUpScreen()),
          GoRoute(path: RouterPath.forgotPassword, builder: (context, state) => ForgotPasswordScreen()),
          GoRoute(path: RouterPath.langding_page, builder: (context, state) => LangdingScreen()),
          GoRoute(
            path: RouterPath.resetPassword,
            builder: (context, state) { return NewPasswordScreen();
            }
          ),
          GoRoute(
            path: RouterPath.verifyEmail,
            builder: (context, state) {
              return LangdingScreen();
            }
          ),
          GoRoute(
            path: RouterPath.otpVerification,
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              return OtpVerificationScreen(email: email);
            }
          ),
          GoRoute(
            path: RouterPath.addEvent,
            name: RouterName.addEvent,
            builder: (context, state) => AddEventPage(),
          ),
          GoRoute(
            path: RouterPath.eventsList,
            name: RouterName.eventsList,
            builder: (context, state) => EventsListPage(),
          ),
          GoRoute(
            path: RouterPath.eventDetails,
            name: RouterName.eventDetails,
            builder: (context, state) => EventDetailsPage(),
          ),
          GoRoute(
            path: RouterPath.categories,
            name: RouterName.categories,
            builder: (context, state) => CategoriesPage(),
          ),
          GoRoute(
            path: RouterPath.ticketTypes,
            name: RouterName.ticketTypes,
            builder: (context, state) => TicketTypesPage(),
          ),
          ShellRoute(
            routes: [
              GoRoute(
                path: RouterPath.dashboard,
                name: RouterName.dashboard,
                builder: (context, state) => DashboardPage(),
              ),
              GoRoute(
                path: RouterPath.events,
                name: RouterName.events,
                builder: (context, state) => EventsPage(),
              ),
              GoRoute(
                path: RouterPath.orders,
                name: RouterName.orders,
                builder: (context, state) {

                  return OrdersPage();
                },
              ),
              GoRoute(
                path: RouterPath.users,
                name: RouterName.users,
                builder: (context, state) => const UsersPage(),
              ),
              GoRoute(
                path: RouterPath.settings,
                name: RouterName.assets,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
            builder: (context, state, child) => MainScreen(child: child),
          ),
        ],
        redirect: (context, state) async {},
        refreshListenable: authNotifier,
      ) {
      }
}
