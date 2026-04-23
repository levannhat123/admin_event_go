import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/base/base_view.dart';
import '../../view_models/auth_view_model.dart';
import 'add_staff_screen.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      onModelReady: (vm) {
        vm.fetchStaff();
      },
      autoDispose: false,
      builder: (context, vm, child) {
        final staffList = vm.staffList.where((e) => e.role == "staff").toList();
        print("STAFF LIST LENGTH: ${staffList.length}");
        return Scaffold(
          backgroundColor: AppColors.slateDark,

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditStaffScreen()),
              );

              if (result == true) vm.fetchStaff();
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),

          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : staffList.isEmpty
              ? const Center(
                  child: Text(
                    AppStrings.noStaffFound,
                    style: TextStyle(color: Colors.white38),
                  ),
                )
              : _buildStaffList(staffList, vm),
        );
      },
      viewModelBuilder: () => getIt<AuthViewModel>(),
    );
  }

  Widget _buildStaffList(List staffList, AuthViewModel vm) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.size16),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        print("ROLE: ${staff.role}");
        final originalIndex = vm.staffList.indexOf(staff);
        return Slidable(
          key: ValueKey(staff.id),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                label: AppStrings.editLabel,
                backgroundColor: Colors.blue,
                icon: Icons.edit,
                onPressed: (_) async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditStaffScreen(staffData: staff),
                    ),
                  );

                  if (updated == true) vm.fetchStaff();
                },
              ),
              SlidableAction(
                label: AppStrings.deleteLabel,
                backgroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (_) async {
                  _showDeleteDialog(
                    context,
                    vm,
                    staff.id,
                    staff.email ?? AppStrings.fallbackUserEmail,
                  );
                },
              ),
            ],
          ),

          child: Container(
            padding: const EdgeInsets.all(AppSizes.size16),
            margin: const EdgeInsets.only(bottom: AppSizes.size12),
            decoration: BoxDecoration(
              color: AppColors.slateCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    staff.fullName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: AppSizes.size20,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: AppSizes.size16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.size17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        staff.email,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        staff.phone,
                        style: const TextStyle(color: Colors.white38),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.size10,
                    vertical: AppSizes.size4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    staff.role,
                    style: const TextStyle(color: Colors.purpleAccent),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AuthViewModel vm,
      String staffId,
    String email,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.slateCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppStrings.deleteUserDialogTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '${AppStrings.deleteUserDialogContentPrefix}$email'
            '${AppStrings.deleteUserDialogContentSuffix}',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.cancelButton,
                style: const TextStyle(color: Colors.white60),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await vm.deleteStaff(staffId);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redAccent,
              ),
              child: Text(
                AppStrings.deleteButton,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
