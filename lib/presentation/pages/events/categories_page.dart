import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/widgets/custom_no_data.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/category_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.slateCard,
        centerTitle: true,
        title: const Text(
          AppStrings.categoriesNavTitle,
          style: TextStyle(
              fontSize: AppSizes.size24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BaseView<CategoryViewModel>(
        padding: false,
        viewModelBuilder: () => getIt<CategoryViewModel>(),
        onModelReady: (vm) => vm.watchAll(),
        builder: (context, vm, child) {
          if (vm.isBusy && vm.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.categories.isEmpty) {
            return _buildEmpty(vm);
          }
          return RefreshIndicator(
            onRefresh: () => vm.getAll(),
            backgroundColor: AppColors.slateCard,
            color: AppColors.indigoAccent,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.size16),
              itemCount: vm.categories.length,
              itemBuilder: (context, index) => _buildCategoryItem(vm, vm.categories[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditPage(),
        backgroundColor: AppColors.amberAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          AppStrings.addCategoryButton,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmpty(CategoryViewModel? vm) {
    return Center(child: Center(child: CustomNoData()));
  }

  Widget _buildCategoryItem(CategoryViewModel vm, CategoryModel category) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.size16),
      decoration: BoxDecoration(
        color: AppColors.slateCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(245, 158, 11, 0.3), width: AppSizes.size1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSizes.size16),
        leading: Container(
          padding: EdgeInsets.all(AppSizes.size12),
          decoration: BoxDecoration(
            color: Color.fromRGBO(245, 158, 11, 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.category, color: AppColors.amberAccent, size: 24),
        ),
        title: Text(
          category.name,
          style: TextStyle(
              fontSize: AppSizes.size16,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSizes.size8),
          child: Text(
            '${AppStrings.categoryIdPrefix}${category.id}',
            style: const TextStyle(
                fontSize: AppSizes.size14,
                color: Color.fromRGBO(255, 255, 255, 0.6)),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.amberAccent),
              onPressed: () => _openEditPage(category: category),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(vm, category),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditPage({CategoryModel? category}) async {
    final result = await context.push<CategoryModel>(RouterPath.editCategory, extra: category);

    if (result != null) {
      final vm = getIt<CategoryViewModel>();
      final exists = vm.categories.any((c) => c.id == result.id);
      if (exists) {
        await vm.update(result.id, result);
      } else {
        await vm.add(result);
      }
    }
  }

  void _confirmDelete(CategoryViewModel vm, CategoryModel category) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateDark,
        title: const Text(AppStrings.deleteCategoryTitle,
            style: TextStyle(color: Colors.white)),
        content: Text(
          '${AppStrings.deleteCategoryContentPrefix}${category.name}'
          '${AppStrings.deleteCategoryContentSuffix}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(AppStrings.cancelButton,
                style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              context.pop();
              final success = await vm.delete(category.id);
              if (!success) {
                final message = vm.errorMessage ?? AppStrings.deleteCategoryFailed;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
            },
            child: const Text(AppStrings.deleteButton,
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
