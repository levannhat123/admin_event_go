import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class AuthBottomSheetWidget extends StatelessWidget {
  final Widget child;
  final double? heightFactor;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double minChildSize;
  final double maxChildSize;

  const AuthBottomSheetWidget({
    super.key,
    required this.child,
    this.heightFactor,
    this.isScrollControlled = true,
    this.backgroundColor,
    this.shape,
    this.minChildSize = 0.5,
    this.maxChildSize = 0.8,
  });

  /// Static method to show the bottom sheet.
  /// Ensures keyboard management and focus handling.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double minChildSize = 0.5,
    double maxChildSize = 0.8,
    bool isScrollControlled = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) async {
    // Unfocus any previous input before showing bottom sheet
    FocusScope.of(context).unfocus();
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final theme = Theme.of(context);

    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.size16),
            ),
          ),
      constraints: BoxConstraints(
        minWidth: mediaQuery.size.width,
        maxWidth: mediaQuery.size.width,
        minHeight: isLandscape
            ? mediaQuery.size.height
            : mediaQuery.size.height * minChildSize,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: minChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: ShapeDecoration(
              color: backgroundColor ?? theme.scaffoldBackgroundColor,
              shape:
                  shape ??
                   RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.size16),
                    ),
                  ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: child,
            ),
          ),
        ),
      ),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: minChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) =>
            SingleChildScrollView(controller: scrollController, child: child),
      ),
    );
  }
}
