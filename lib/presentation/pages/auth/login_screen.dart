import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_image.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_spacing.dart';
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
                    color: AppColors.brandPrimary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.size40),
                      bottomRight: Radius.circular(AppSizes.size40),
                    ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(top: AppSpacing.space60),
                    child: Column(
                      children: [
                        CircleAvatar(backgroundImage: AssetImage(AppImage.logo), radius: AppSizes.size40),
                        SizedBox(height: AppSizes.size20),
                        Text(
                          AppStrings.loginTitle,
                          style: TextStyle(
                            color: AppColors.brandWarning,
                            fontSize: AppSizes.size24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSizes.size10),
                        Text(
                          AppStrings.loginDescription,
                          style: TextStyle(color: AppColors.brandWarning, fontSize: AppSizes.size12),
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
                  padding:  EdgeInsets.all(AppSpacing.space20),
                  height: MediaQuery.of(context).size.height * AppSizes.size0_7,
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.size30),
                      topRight: Radius.circular(AppSizes.size30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          controller: emailController,
                          hintText: AppStrings.emailLabel,
                          borderColor: Colors.grey.shade300,
                          fillColor: Colors.grey.shade100,
                          validator: Validator.email,
                          suffixIcon: IconButton(
                            onPressed: () {
                              emailController.clear();
                            },
                            icon: SvgPicture.asset(
                              AppSvg.close,
                              width: AppSizes.size24,
                              height: AppSizes.size24,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorderColor: AppColors.brandPrimary,
                          enabledBorderColor: Colors.grey.shade300,
                          prefixIcon: const Icon(Icons.email),
                          shadowColor: AppColors.transparent,
                        ),
                         SizedBox(height: AppSizes.size10),
                        AppTextFieldPassword(
                          controller: passwordController,
                          hintText: AppStrings.passwordHint,
                          borderColor: Colors.grey.shade300,
                          validator: Validator.password,
                          fillColor: Colors.grey.shade100,
                          focusedBorderColor: AppColors.brandPrimary,
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
                                style: TextStyle(color: AppColors.brandWarning),
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: AppSizes.size10),
                        viewModel.isLoading
                            ? Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color:AppColors.brandWarning,
                                  size: AppSizes.size50,
                                ),
                              )
                            : AppElevatedButton(
                                text: AppStrings.loginButton,
                                borderColor: AppColors.brandWarning,
                                color: AppColors.brandWarning,
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
                                        title: AppStrings.loginSuccessDialogTitle,
                                        message: AppStrings.loginSuccessDialogMessage,
                                        buttonText: AppStrings.dialogOkButton,
                                        icon: Icons.check_circle,
                                        iconColor: Colors.green,
                                        onPressed: () {
                                          context.go(RouterPath.dashboard);
                                        },
                                      );
                                    } else {
                                      await showCustomDialog(
                                        context: context,
                                        title: AppStrings.loginFailedDialogTitle,
                                        message: viewModel.errorMessage ??
                                            AppStrings.loginFailedDefaultMessage,
                                        buttonText: AppStrings.dialogOkButton,
                                        icon: Icons.error,
                                        iconColor: Colors.red,
                                        onPressed: () {},
                                      );
                                    }
                                  }
                                },
                              ),
                        const SizedBox(height: AppSizes.size20),
                        RichText(
                          text: TextSpan(
                            text: AppStrings.noAccount,
                            style: TextStyle(color: Colors.grey, fontSize: AppSizes.size14),
                            children: [
                              TextSpan(
                                text: AppStrings.signUpButton,
                                style: TextStyle(
                                  color: AppColors.brandWarning,
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
