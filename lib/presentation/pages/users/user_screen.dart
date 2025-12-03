import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_no_data.dart';
import '../../view_models/auth_view_model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Color(0xFF0F172A),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.fetchUsers(),
                  backgroundColor: const Color(0xFF1E293B),
                  color: const Color(0xFF6366F1),
                  child: vm.userList.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const Center(child: CustomNoData()),
                            ),
                          ],
                        )
                      : _buildUsersList(vm),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersList(AuthViewModel vm) {
    if (vm.userList.isEmpty) {
      return const Center(child: CustomNoData());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.userList.length,
      itemBuilder: (context, index) {
        final user = vm.userList[index];
        final originalIndex = vm.userList.indexOf(user);
        return Slidable(
          key: ValueKey(user.id),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  _showDeleteDialog(
                    context,
                    vm,
                    originalIndex,
                    user.email ?? 'this users',
                  );

                  // TODO: Delete
                },
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: AppStrings.deleteLabel,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        (user.email ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.email ?? AppStrings.noEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 12,
                                    color: Color(0xFF10B981),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    AppStrings.activeStatus,
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${AppStrings.categoryIdPrefix}${user.id.substring(0, 8)}...',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white60),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AuthViewModel vm,
    int index,
    String email,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppStrings.deleteUserDialogTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            '${AppStrings.deleteUserDialogContentPrefix}$email'
            '${AppStrings.deleteUserDialogContentSuffix}',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.cancelButton,
                  style: const TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                vm.deleteUser(vm.userList[index].id);
                vm.userList.removeAt(index);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
              ),
              child: Text(AppStrings.deleteButton,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
