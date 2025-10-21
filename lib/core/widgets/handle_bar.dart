import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_sizes.dart';


class HandleBar extends StatelessWidget {
  const HandleBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.size68.w,
      height: AppSizes.size2.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(AppSizes.size8.r),
      ),
    );
  }
}
