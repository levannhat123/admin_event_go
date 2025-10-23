import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';

class WatchAllCategoriesUsecase {
  final CategoryRepository categoryRepository;

  WatchAllCategoriesUsecase(this.categoryRepository);

  Stream<List<CategoryModel>> call() {
    try {
      return categoryRepository.watchAllCategories();
    } catch (e) {
      rethrow;
    }
  }
}

