import 'package:flutter/material.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppSizes.size16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSizes.size10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppSizes.size14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: AppSizes.size20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandWarning,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.size40,
                      vertical: AppSizes.size12,
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -40,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonText,
  required IconData icon,
  required Color iconColor,
  required VoidCallback onPressed,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        icon: icon,
        iconColor: iconColor,
        onPressed: () {
          Navigator.of(context).pop();
          onPressed();
        },
      );
    },
  );
}
