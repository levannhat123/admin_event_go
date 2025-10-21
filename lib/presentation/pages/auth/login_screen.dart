import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_image.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/constants/app_svg.dart';
import 'package:admin_event_go/core/utils/validator.dart';
import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/core/widgets/showdialog.dart';
import 'package:admin_event_go/core/widgets/text_field.dart';
import 'package:admin_event_go/core/widgets/text_field_password.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/auth_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                        SizedBox(height: 10),
                        Text(
                          AppStrings.loginTitle,
                          style: TextStyle(
                            color: Color(0xFFf49415),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppStrings.loginDescription,
                          style: TextStyle(color: Color(0xFFf49415), fontSize: 12),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                      children: [
                        AppTextField(
                          controller: emailController,
                          hintText: 'Email',
                          borderColor: Colors.grey.shade300,
                          fillColor: Colors.grey.shade100,
                          validator: Validator.email,
                          suffixIcon: IconButton(
                            onPressed: () {
                              emailController.clear();
                            },
                            icon: SvgPicture.asset(
                              AppSvg.close,
                              width: 24,
                              height: 24,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorderColor: const Color(0xFF4257b4),
                          enabledBorderColor: Colors.grey.shade300,
                          prefixIcon: const Icon(Icons.email),
                          shadowColor: AppColors.transparent,
                        ),
                        const SizedBox(height: 20),
                        AppTextFieldPassword(
                          controller: passwordController,
                          hintText: AppStrings.passwordHint,
                          borderColor: Colors.grey.shade300,
                          validator: Validator.password,
                          fillColor: Colors.grey.shade100,
                          focusedBorderColor: const Color(0xFF4257b4),
                          enabledBorderColor: Colors.grey.shade300,
                          shadowColor: AppColors.transparent,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                context.push(RouterPath.forgotPassword);
                              },
                              child: const Text(
                                AppStrings.forgotPasswordButton,
                                style: TextStyle(color: Color(0xFFf49415)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        viewModel.isLoading
                            ? Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color:Color(0xFFf49415),
                                  size: AppSizes.size50,
                                ),
                              )
                            : AppElevatedButton(
                                text: AppStrings.loginButton,
                                borderColor: Color(0xFFf49415),
                                color: Color(0xFFf49415),
                                splashColor: AppColors.transparent,
                                highlightColor: AppColors.white,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await viewModel.login(
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );
                                    if (success) {
                                      await showCustomDialog(
                                        context: context,
                                        title: "ĐĂNG NHẬP THÀNH CÔNG",
                                        message: "Bạn đã đăng nhập thành công!",
                                        buttonText: "Okay",
                                        icon: Icons.check_circle,
                                        iconColor: Colors.green,
                                        onPressed: () {
                                          context.go(RouterPath.dashboard);
                                        },
                                      );
                                    } else {
                                      await showCustomDialog(
                                        context: context,
                                        title: "ĐĂNG NHẬP THẤT BẠI",
                                        message:
                                            viewModel.errorMessage ?? "Sai email hoặc mật khẩu",
                                        buttonText: "Okay",
                                        icon: Icons.error,
                                        iconColor: Colors.red,
                                        onPressed: () {},
                                      );
                                    }
                                  }
                                },
                              ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: AppStrings.noAccount,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: AppStrings.signUpButton,
                                style: TextStyle(
                                  color: Color(0xFFf49415),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push(RouterPath.sign_up);
                                  },
                              ),
                            ],
                          ),
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
