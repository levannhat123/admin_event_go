import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_image.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImage.no_data, width: AppSizes.size100.w, height: AppSizes.size100.h),
          SizedBox(height: AppSizes.size16.h),
          Text(
            AppStrings.noData,
            style: AppTextStyles.body.copyWith(color: AppColors.textNoData),
          ),
        ],
      ),
    );
  }
}
