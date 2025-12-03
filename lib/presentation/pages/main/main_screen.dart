import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/constants/app_svg.dart';
import 'package:admin_event_go/core/widgets/custom_navbottom_bar.dart';
import 'package:admin_event_go/data/models/navbar/nav_item.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  static List<NavItem> navItems(BuildContext context) => [
    NavItem(
      icon: AppSvg.home,
      label: AppStrings.navDashboard,
      route: RouterPath.dashboard,
    ),
    NavItem(
      icon: AppSvg.event,
      label: AppStrings.navEvents,
      route: RouterPath.events,
    ),
    NavItem(
      icon: AppSvg.order,
      label: AppStrings.navOrders,
      route: RouterPath.orders,
      isCenter: true,
    ),
    NavItem(
      icon: AppSvg.user,
      label: AppStrings.navUsers,
      route: RouterPath.users,
    ),
  ];


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = MainScreen.navItems(
      context,
    ).indexWhere((item) => item.route == location);
    return Scaffold(
      body: Column(children: [Expanded(child: widget.child)]),
      bottomNavigationBar: CustomNavBar(
        items: MainScreen.navItems(context),
        currentIndex: currentIndex == -1 ? 0 : currentIndex,
        onTap: (index) {
          context.go(MainScreen.navItems(context)[index].route);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
