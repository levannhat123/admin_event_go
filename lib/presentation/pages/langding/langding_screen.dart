import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_image.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/constants/app_text_styles.dart';
import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LangdingScreen extends StatefulWidget {
  const LangdingScreen({Key? key}) : super(key: key);

  @override
  State<LangdingScreen> createState() => _LangdingScreenState();
}

class _LangdingScreenState extends State<LangdingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImage.langding_page, fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 37.0, right: 37.0, bottom: 64.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.heading,
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    AppStrings.slogan,
                    style: AppTextStyles.content2,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20.0),
                  AppElevatedButton(
                    text: AppStrings.getStarted,
                    textColor: AppColors.white,
                    color: Color(0xFFf49415),
                    fontSize: 15.0,
                    borderColor: Color(0xFFf49415),
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.white,
                    onPressed: () {
                      context.push(RouterPath.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
