import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_text_styles.dart';
import 'package:admin_event_go/data/models/navbar/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final Function(int index) onTap;

  const CustomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.size72,
      color: AppColors.navBottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.icon,
                  width: AppSizes.size24.w,
                  height: AppSizes.size24.h,
                  color: (isSelected ? AppColors.primary : AppColors.iconUnselected),
                ),
                const SizedBox(height: AppSizes.size4),
                Text(
                  item.label,
                  style: AppTextStyles.primaryLabel.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.iconUnselected,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
