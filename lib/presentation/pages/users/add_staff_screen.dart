import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../view_models/auth_view_model.dart';
import '../../../data/models/profile_model.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

class AddEditStaffScreen extends StatefulWidget {
  final ProfileModel? staffData;

  const AddEditStaffScreen({Key? key, this.staffData}) : super(key: key);

  @override
  State<AddEditStaffScreen> createState() => _AddEditStaffScreenState();
}

class _AddEditStaffScreenState extends State<AddEditStaffScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  String role = AppStrings.staffRoleStaff;

  bool get isEdit => widget.staffData != null;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.staffData?.fullName ?? "");
    emailCtrl = TextEditingController(text: widget.staffData?.email ?? "");
    phoneCtrl = TextEditingController(text: widget.staffData?.phone ?? "");
    role = widget.staffData?.role ?? AppStrings.staffRoleStaff;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      viewModelBuilder: () => getIt<AuthViewModel>(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.slateDark,
          appBar: AppBar(
            backgroundColor: AppColors.slateCard,
            title: Text(isEdit ? AppStrings.editStaffTitle : AppStrings.addStaffTitle),
          ),

          body: Padding(
            padding: const EdgeInsets.all(AppSizes.size16),
            child: ListView(
              children: [
                _input(AppStrings.fullNameLabel, nameCtrl),
                _input(AppStrings.emailLabel, emailCtrl),
                _input(AppStrings.phoneLabel, phoneCtrl),

                DropdownButtonFormField(
                  value: role,
                  dropdownColor: AppColors.slateCard,
                  decoration: _decor(AppStrings.roleLabel),
                  items: [
                    AppStrings.staffRoleStaff,
                    AppStrings.staffRoleAdmin,
                    AppStrings.staffRoleUser
                  ]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(color: Colors.white)),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => role = v!),
                ),

                const SizedBox(height: AppSizes.size20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.size14)),
                  child: Text(
                    isEdit ? AppStrings.saveChangesButton : AppStrings.addStaffButton,
                    style: const TextStyle(fontSize: AppSizes.size18),
                  ),
                  onPressed: () async {
                    if (isEdit) {
                      await vm.updateStaff(
                        id: widget.staffData!.id,
                        fullName: nameCtrl.text,
                        email: emailCtrl.text,
                        phone: phoneCtrl.text,
                        avatarUrl: "",
                        role: role,
                      );
                    } else {
                      await vm.createStaff(
                        fullName: nameCtrl.text,
                        email: emailCtrl.text,
                        phone: phoneCtrl.text,
                        avatarUrl: "",
                        role: role,
                      );
                    }

                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.size12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: _decor(label),
      ),
    );
  }

  InputDecoration _decor(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white38),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
