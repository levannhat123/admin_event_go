import 'dart:io';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';

class ImagePickerWidget extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final File? imageFile;
  final double height;
  final Function(File?) onImageSelected;

  const ImagePickerWidget({
    Key? key,
    required this.label,
    this.imageUrl,
    this.imageFile,
    this.height = 150,
    required this.onImageSelected,
  }) : super(key: key);

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.size14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: AppSizes.size8),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                width: AppSizes.size2,
                style: BorderStyle.solid,
              ),
              image: _getImageDecoration(),
            ),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  DecorationImage? _getImageDecoration() {
    if (imageFile != null) {
      return DecorationImage(
        image: FileImage(imageFile!),
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(imageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  Widget _buildContent() {
    // Nếu đã có ảnh, hiển thị overlay khi hover
    if (imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty)) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.edit,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: AppSizes.size8),
              Text(
                AppStrings.imagePickerTapToChange,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.size14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSizes.size16),
            ],
          ),
        ),
      );
    }

    // Nếu chưa có ảnh, hiển thị icon camera
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.size12),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              color: AppColors.brandPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSizes.size8),
          Text(
            AppStrings.imagePickerTapToSelect,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: AppSizes.size13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.size2),
          Text(
            AppStrings.imagePickerFromGallery,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: AppSizes.size11,
            ),
          ),
        ],
      ),
    );
  }
}
