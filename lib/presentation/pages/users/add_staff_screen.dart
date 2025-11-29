import 'package:admin_event_go/injection/injection.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../view_models/auth_view_model.dart';
import '../../../data/models/profile_model.dart';

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

  String role = "staff";

  bool get isEdit => widget.staffData != null;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.staffData?.fullName ?? "");
    emailCtrl = TextEditingController(text: widget.staffData?.email ?? "");
    phoneCtrl = TextEditingController(text: widget.staffData?.phone ?? "");
    role = widget.staffData?.role ?? "staff";
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      viewModelBuilder: () => getIt<AuthViewModel>(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            title: Text(isEdit ? "Edit Staff" : "Add Staff"),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _input("Full Name", nameCtrl),
                _input("Email", emailCtrl),
                _input("Phone", phoneCtrl),

                DropdownButtonFormField(
                  value: role,
                  dropdownColor: const Color(0xFF1E293B),
                  decoration: _decor("Role"),
                  items: ["staff", "admin", "user"]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(color: Colors.white)),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => role = v!),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(
                    isEdit ? "Save Changes" : "Add Staff",
                    style: const TextStyle(fontSize: 18),
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
      padding: const EdgeInsets.only(bottom: 12),
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
