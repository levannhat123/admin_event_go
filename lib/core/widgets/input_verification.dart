import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

class InputVerification extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String, int) onChanged;
  final bool autoFocus;

  const InputVerification({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return SizedBox(
          width: AppSizes.size55.w,
          child: TextField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            autofocus: autoFocus && i == 0,
            style: AppTextStyles.heading1.copyWith(
              fontSize: AppSizes.size24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              contentPadding: EdgeInsets.zero.w.h,
              fillColor: AppColors.secondary,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.size8),
                borderSide: const BorderSide(
                  color: AppColors.borderInput,
                  width: AppSizes.size1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.size8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: AppSizes.size2,
                ),
              ),
            ),
            onChanged: (value) => onChanged(value, i),
            onTap: () => controllers[i].selection = TextSelection(
              baseOffset: 0,
              extentOffset: controllers[i].text.length,
            ),
          ),
        );
      }),
    );
  }
}
