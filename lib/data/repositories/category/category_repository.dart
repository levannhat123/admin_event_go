import 'package:admin_event_go/data/models/category/category_model.dart';

abstract class CategoryRepository {
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(String categoryId, CategoryModel category);
  Future<void> deleteCategory(String categoryId);
  Future<CategoryModel?> getCategoryById(String categoryId);
  Future<List<CategoryModel>> getAllCategories();
  Stream<List<CategoryModel>> watchAllCategories();
}
