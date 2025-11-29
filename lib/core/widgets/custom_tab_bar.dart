import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final Color? backgroundColor;
  final List<Tab> tabs;
  final Color? labelColor;
  final Color? dividerColor;
  final int? dividerHeight;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final EdgeInsetsGeometry? labelPadding;
  final double? containerLeftPadding;
  final double? tabBarLeftPadding;
  final double? tabBarRightPadding;
  final Widget? trailing;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.backgroundColor = Colors.transparent,
    this.labelColor = AppColors.white,
    this.dividerColor = AppColors.divider,
    this.dividerHeight = 1,
    this.unselectedLabelColor = AppColors.iconUnselected,
    this.indicatorColor = AppColors.primary,
    this.labelPadding,
    this.containerLeftPadding = AppSpacing.space0,
    this.tabBarLeftPadding = AppSpacing.space10,
    this.tabBarRightPadding = AppSpacing.space10,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: containerLeftPadding!.w),
      color: backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  padding: EdgeInsets.only(left: tabBarLeftPadding!.w),
                  splashFactory: NoSplash.splashFactory,
                  isScrollable: true,
                  tabs: tabs,
                  tabAlignment: TabAlignment.start,
                  controller: controller,
                  labelColor: labelColor,
                  dividerColor: dividerColor,
                  dividerHeight: trailing != null
                      ? AppSpacing.space0.toDouble()
                      : dividerHeight!.h,
                  unselectedLabelColor: unselectedLabelColor,
                  indicatorColor: indicatorColor,
                  labelPadding:
                  labelPadding ??
                      EdgeInsets.symmetric(horizontal: AppSpacing.space10.w),
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: EdgeInsets.only(right: tabBarRightPadding!.w),
                  child: trailing,
                ),
            ],
          ),
          if (trailing != null)
            Container(
              width: double.infinity,
              height: dividerHeight!.h,
              color: dividerColor,
            ),
        ],
      ),
    );
  }
}
