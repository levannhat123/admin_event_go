import 'package:admin_event_go/data/repositories/category/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository categoryRepository;

  DeleteCategoryUsecase(this.categoryRepository);

  Future<void> call(String id) async {
    try {
      await categoryRepository.deleteCategory(id);
    } catch (e) {
      rethrow;
    }
  }
}

