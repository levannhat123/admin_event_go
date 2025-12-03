import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/widgets/custom_no_data.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/pages/users/staff_screen.dart';
import 'package:admin_event_go/presentation/pages/users/user_screen.dart';
import 'package:admin_event_go/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/widgets/custom_tab_bar.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Tab> tabs;
  String searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      const Tab(text: AppStrings.usersTabUsers),
      const Tab(text: AppStrings.usersTabStaff)
    ];
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        title: const Text(
          AppStrings.usersManagementTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BaseView(
        viewModelBuilder: () => getIt<AuthViewModel>(),
        onModelReady: (viewModel) {
          // viewModel.fetchAllUsers();
        },
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomTabBar(controller: _tabController, tabs: tabs),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [UserScreen(), StaffScreen()],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
