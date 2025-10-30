import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';

class AddCategoryUsecase {
  final CategoryRepository categoryRepository;

  AddCategoryUsecase(this.categoryRepository);

  Future<void> call(CategoryModel category) async {
    try {
      await categoryRepository.addCategory(category);
    } catch (e) {
      rethrow;
    }
  }
}

