import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';

class CategoryEditPage extends StatefulWidget {
  final CategoryModel? category;
  const CategoryEditPage({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final id = widget.category?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final result = CategoryModel(id: id, name: name);
      context.pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;
    return Scaffold(
      backgroundColor: AppColors.slateDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.slateCard,
        centerTitle: true,
        title: Text(
          isEdit ? AppStrings.categoryEditTitle : AppStrings.categoryAddTitle,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.size16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: AppTextField(
                hintText: AppStrings.categoryNameHint,
                controller: _nameController,
                borderColor: Colors.grey.shade300,
                fillColor: Colors.grey.shade100,
                focusedBorderColor: AppColors.brandPrimary,
                enabledBorderColor: Colors.grey.shade300,
                shadowColor: AppColors.transparent,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.categoryNameRequired;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: AppSizes.size24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AppElevatedButton(
                    onPressed: () => context.pop(),
                    text: AppStrings.cancelShort,
                    borderColor: Colors.grey.shade300,
                    color: Colors.white,
                    textColor: Colors.black87,
                  ),
                ),
                const SizedBox(width: AppSizes.size12),
                Expanded(
                  child: AppElevatedButton(
                    onPressed: _onSave,
                    text: isEdit ? AppStrings.saveShort : AppStrings.addShort,
                    borderColor: AppColors.primary,
                    color: AppColors.primary,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
