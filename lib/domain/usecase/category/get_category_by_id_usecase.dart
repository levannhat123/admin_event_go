import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';

class GetCategoryByIdUsecase {
  final CategoryRepository categoryRepository;

  GetCategoryByIdUsecase(this.categoryRepository);

  Future<CategoryModel?> call(String id) async {
    try {
      return await categoryRepository.getCategoryById(id);
    } catch (e) {
      rethrow;
    }
  }
}

