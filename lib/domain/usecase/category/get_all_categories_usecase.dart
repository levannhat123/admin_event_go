import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';

class GetAllCategoriesUsecase {
  final CategoryRepository categoryRepository;

  GetAllCategoriesUsecase(this.categoryRepository);

  Future<List<CategoryModel>> call() async {
    try {
      return await categoryRepository.getAllCategories();
    } catch (e) {
      rethrow;
    }
  }
}

