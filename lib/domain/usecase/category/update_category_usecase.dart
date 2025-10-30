import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';

class UpdateCategoryUsecase {
  final CategoryRepository categoryRepository;

  UpdateCategoryUsecase(this.categoryRepository);

  Future<void> call(String id, CategoryModel category) async {
    try {
      await categoryRepository.updateCategory(id, category);
    } catch (e) {
      rethrow;
    }
  }
}

