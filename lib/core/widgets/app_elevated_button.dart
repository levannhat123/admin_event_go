import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';

class AppElevatedButton extends StatelessWidget {
  AppElevatedButton({
    super.key,
    this.onPressed,
    this.height = 48.0,
    this.color = AppColors.red,
    this.gradient,
    this.borderColor = AppColors.red,
    required this.text,
    this.textColor = AppColors.white,
    this.fontSize = 16.0,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.size12),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(10.0),
       splashColor = splashColor ?? AppColors.yellow.withOpacity(0.8),
       highlightColor = highlightColor ?? AppColors.green.withOpacity(0.8);

  AppElevatedButton.outline({
    super.key,
    this.onPressed,
    this.height = 48.0,
    this.color = AppColors.white,
    this.gradient,
    this.borderColor = AppColors.red,
    required this.text,
    this.textColor = AppColors.red,
    this.fontSize = 16.0,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.size12),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(10.0),
       splashColor = splashColor ?? AppColors.yellow.withOpacity(0.6),
       highlightColor = highlightColor ?? AppColors.green.withOpacity(0.6);

  AppElevatedButton.small({
    super.key,
    this.onPressed,
    this.height = 38.0,
    this.color = AppColors.red,
    this.gradient,
    this.borderColor = AppColors.red,
    required this.text,
    this.textColor = AppColors.white,
    this.fontSize = 14.6,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.size12),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(8.0),
       splashColor = splashColor ?? AppColors.yellow.withOpacity(0.8),
       highlightColor = highlightColor ?? AppColors.green.withOpacity(0.8);

  AppElevatedButton.smallOutline({
    super.key,
    this.onPressed,
    this.height = 38.0,
    this.color = AppColors.white,
    this.gradient,
    this.borderColor = AppColors.red,
    required this.text,
    this.textColor = AppColors.red,
    this.fontSize = 14.6,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.size12),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(8.0),
       splashColor = splashColor ?? AppColors.yellow.withOpacity(0.6),
       highlightColor = highlightColor ?? AppColors.green.withOpacity(0.6);

  final Function()? onPressed;
  final double height;
  final Color color;
  final Gradient? gradient;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final SvgPicture? icon;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isDisable;
  final Color splashColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: isDisable ? null : onPressed,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: Ink(
          padding: padding,
          height: height,
          decoration: BoxDecoration(
            color: gradient == null ? color : null,
            gradient: gradient,
            border: Border.all(color: borderColor, width: AppSizes.size1_4),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: AppSizes.size30)],
              isDisable
                  ? Center(
                      child: SizedBox.square(
                        dimension: height - 22.0,
                        child: CircularProgressIndicator(color: textColor, strokeWidth: 2.2),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
