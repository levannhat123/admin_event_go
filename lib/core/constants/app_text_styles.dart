import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static final heading1 = TextStyle(
    fontSize: AppSizes.size32.sp,
    fontWeight: FontWeight.w700,
  );

  static final heading2 = TextStyle(
    fontSize: AppSizes.size24.sp,
    fontWeight: FontWeight.w600,
  );

  static final title1 = TextStyle(
    fontSize: AppSizes.size20.sp,
    fontWeight: FontWeight.w700,
  );

  static final title2 = TextStyle(
    fontSize: AppSizes.size16.sp,
    fontWeight: FontWeight.w600,
  );

  static final subtitle = TextStyle(
    fontSize: AppSizes.size16.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle content5 = TextStyle(
    fontSize: AppSizes.size18.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle content4 = TextStyle(
    fontSize: AppSizes.size16.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle content3 = TextStyle(
    fontSize: AppSizes.size14.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle content2 = TextStyle(
    fontSize: AppSizes.size12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle content1 = TextStyle(
    fontSize: AppSizes.size10.sp,
    fontWeight: FontWeight.w400,
  );

  static final primaryLabel = TextStyle(
    fontSize: AppSizes.size14.sp,
    fontWeight: FontWeight.w600,
  );

  static final body = TextStyle(
    fontSize: AppSizes.size14.sp,
    fontWeight: FontWeight.w400,
  );

  static final subBody = TextStyle(
    fontSize: AppSizes.size14.sp,
    fontWeight: FontWeight.w300,
  );

  static final caption = body.copyWith(fontSize: AppSizes.size12.sp);

  static final smallTextButton = TextStyle(
    fontSize: AppSizes.size14.sp,
    fontWeight: FontWeight.w500,
  );
  static final mediumTextButton = TextStyle(
    fontSize: AppSizes.size14.sp,
    fontWeight: FontWeight.w700,
  );
  static final largeTextButton = mediumTextButton.copyWith();
  static final appbarTitle = content5.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final  number1 = TextStyle(
    fontSize: AppSizes.size36.sp,
    fontWeight: FontWeight.w700,
    fontFamily: "IBM Plex Sans",
    fontStyle: FontStyle.italic,
  );
  static final  smallText = TextStyle(
    fontSize: AppSizes.size8.sp,
    fontWeight: FontWeight.w400,
  );
}
