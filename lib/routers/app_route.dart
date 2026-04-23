import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/presentation/pages/auth/login_screen.dart';
import 'package:admin_event_go/presentation/pages/dashboard/dashboard_page.dart';
import 'package:admin_event_go/presentation/pages/events/category_edit_page.dart';
import 'package:admin_event_go/presentation/pages/events/events_page.dart';
import 'package:admin_event_go/presentation/pages/events/events_list_page.dart';
import 'package:admin_event_go/presentation/pages/events/add_event_page.dart';
import 'package:admin_event_go/presentation/pages/events/categories_page.dart';
import 'package:admin_event_go/presentation/pages/main/main_screen.dart';
import 'package:admin_event_go/presentation/pages/order/order_detail_screen.dart';
import 'package:admin_event_go/presentation/pages/order/orders_page.dart';
import 'package:admin_event_go/presentation/pages/users/users_page.dart';
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
          GoRoute(
            path: RouterPath.login,
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: RouterPath.addEvent,
            name: RouterName.addEvent,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final isEditing = extra?['isEditing'] ?? false;
              final event = extra?['event'] as EventDetailModel?;
              return AddEventPage(isEditing: isEditing, event: event);
            },
          ),
          GoRoute(
            path: RouterPath.eventsList,
            name: RouterName.eventsList,
            builder: (context, state) => EventsListPage(),
          ),

          GoRoute(
            path: RouterPath.categories,
            name: RouterName.categories,
            builder: (context, state) => CategoriesPage(),
          ),
          GoRoute(
            path: RouterPath.editCategory,
            name: RouterName.editCategory,
            builder: (context, state) {
              final category = state.extra as CategoryModel?;
              return CategoryEditPage(category: category);
            },
          ),
          GoRoute(
            path: RouterPath.orders_detail,
            builder: (context, state) {
              final orderData = state.extra as Map<String, dynamic>;
              return OrderDetailScreen(orderData: orderData);
            },
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
            ],
            builder: (context, state, child) => MainScreen(child: child),
          ),
        ],
        redirect: (context, state) async {
          return null;
        },
        refreshListenable: authNotifier,
      ) {}
}
