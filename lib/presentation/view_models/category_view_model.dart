import 'dart:async';

import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:admin_event_go/domain/usecase/category/add_category_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/update_category_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/delete_category_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/get_category_by_id_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/get_all_categories_usecase.dart';
import 'package:admin_event_go/domain/usecase/category/watch_all_categories_usecase.dart';

class CategoryViewModel extends BaseViewModel {
  final AddCategoryUsecase addCategoryUsecase;
  final UpdateCategoryUsecase updateCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;
  final GetCategoryByIdUsecase getCategoryByIdUsecase;
  final GetAllCategoriesUsecase getAllCategoriesUsecase;
  final WatchAllCategoriesUsecase watchAllCategoriesUsecase;

  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  StreamSubscription<List<CategoryModel>>? _subscription;

  List<CategoryModel> get categories => _categories;
  CategoryModel? get selectedCategory => _selectedCategory;

  CategoryViewModel({
    required this.addCategoryUsecase,
    required this.updateCategoryUsecase,
    required this.deleteCategoryUsecase,
    required this.getCategoryByIdUsecase,
    required this.getAllCategoriesUsecase,
    required this.watchAllCategoriesUsecase,
  });

  Future<void> getAll() async {
    setBusy(true);
    clearError();
    try {
      _categories = await getAllCategoriesUsecase.call();
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setError('Failed to load categories: ${e.toString()}');
      setBusy(false);
    }
  }

  void watchAll() {
    _subscription?.cancel();
    setBusy(true);
    clearError();
    try {
      _subscription = watchAllCategoriesUsecase.call().listen((list) {
        _categories = list;
        setBusy(false);
        notifyListeners();
      }, onError: (err) {
        setError('Failed to watch categories: ${err.toString()}');
        setBusy(false);
      });
    } catch (e) {
      setError('Failed to start watching categories: ${e.toString()}');
      setBusy(false);
    }
  }

  Future<bool> add(CategoryModel category) async {
    setBusy(true);
    clearError();
    try {
      await addCategoryUsecase.call(category);
      _categories.insert(0, category);
      setBusy(false);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to add category: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<bool> update(String id, CategoryModel category) async {
    setBusy(true);
    clearError();
    try {
      await updateCategoryUsecase.call(id, category);
      final idx = _categories.indexWhere((c) => c.id == id);
      if (idx != -1) {
        _categories[idx] = category;
      }
      setBusy(false);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to update category: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<bool> delete(String id) async {
    setBusy(true);
    clearError();
    try {
      await deleteCategoryUsecase.call(id);
      _categories.removeWhere((c) => c.id == id);
      setBusy(false);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to delete category: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<void> getById(String id) async {
    setBusy(true);
    clearError();
    try {
      _selectedCategory = await getCategoryByIdUsecase.call(id);
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setError('Failed to get category: ${e.toString()}');
      setBusy(false);
    }
  }

  void clearSelected() {
    _selectedCategory = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
