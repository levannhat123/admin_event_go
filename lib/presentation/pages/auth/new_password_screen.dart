import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_image.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/utils/validator.dart';
import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/core/widgets/showdialog.dart';
import 'package:admin_event_go/core/widgets/text_field.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/auth_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseConfirmPassword;
    }
    if (value != passwordController.text) {
      return AppStrings.confirmPasswordMismatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      padding: false,
      viewModelBuilder: () => getIt<AuthViewModel>(),
      builder: (context, viewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Header với logo
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4257b4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        CircleAvatar(backgroundImage: AssetImage(AppImage.logo), radius: 40),
                        const SizedBox(height: 10),
                        const Text(
                          AppStrings.newPasswordTitle,
                          style: TextStyle(
                            color: Color(0xFFf49415),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.newPasswordDescription,
                          style: const TextStyle(color: Color(0xFFf49415), fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Form content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        // Password field
                        const Text(
                          AppStrings.newPasswordLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          controller: passwordController,
                          hintText: AppStrings.newPasswordHint,
                          borderColor: Colors.grey.shade300,
                          fillColor: Colors.grey.shade100,
                          validator: Validator.password,
                          focusedBorderColor: const Color(0xFF4257b4),
                          enabledBorderColor: Colors.grey.shade300,
                          prefixIcon: const Icon(Icons.lock),
                          shadowColor: AppColors.transparent,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Confirm password field
                        const Text(
                          AppStrings.confirmPasswordLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          controller: confirmPasswordController,
                          hintText: AppStrings.confirmNewPasswordHint,
                          borderColor: Colors.grey.shade300,
                          fillColor: Colors.grey.shade100,
                          validator: _validateConfirmPassword,
                          focusedBorderColor: const Color(0xFF4257b4),
                          enabledBorderColor: Colors.grey.shade300,
                          prefixIcon: const Icon(Icons.lock_outline),
                          shadowColor: AppColors.transparent,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        viewModel.isLoading
                            ? Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color:Color(0xFFf49415),
                            size: AppSizes.size50,
                          ),
                        )
                            :    AppElevatedButton(
                          text: viewModel.isLoading ? AppStrings.updating : AppStrings.resetPasswordButton,
                          borderColor: const Color(0xFFf49415),
                          color: const Color(0xFFf49415),
                          splashColor: AppColors.transparent,
                          highlightColor: AppColors.white,
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await viewModel.updatePassword(
                                      passwordController.text,
                                    );
                                    if (success) {
                                      await showCustomDialog(
                                        context: context,
                                        title: "ĐẶT LẠI MẬT KHẨU THÀNH CÔNG",
                                        message: "Mật khẩu của bạn đã được cập nhật.",
                                        buttonText: "Đăng nhập",
                                        icon: Icons.check_circle,
                                        iconColor: Colors.green,
                                        onPressed: () {
                                          context.push(RouterPath.login);
                                        },
                                      );
                                    } else {
                                      await showCustomDialog(
                                        context: context,
                                        title: "ĐẶT LẠI MẬT KHẨU THẤT BẠI",
                                        message: viewModel.errorMessage ?? "Có lỗi xảy ra, vui lòng thử lại.",
                                        buttonText: "Okay",
                                        icon: Icons.error,
                                        iconColor: Colors.red,
                                        onPressed: () {
                                        },
                                      );
                                    }

                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
