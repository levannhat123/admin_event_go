import 'package:admin_event_go/data/repositories/category/category_repository.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'categories';

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      await _firestore.collection(_collectionName).doc(category.id).set(category.toJson());
      return category;
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection(_collectionName).doc(categoryId).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final query = await _firestore.collection(_collectionName).get();
      return query.docs.map((doc) {
        final Map<String, dynamic> raw = doc.data();
        final data = {
          ...raw,
          'id': raw['id'] ?? doc.id,
        };
        return CategoryModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all categories: $e');
    }
  }

  @override
  Stream<List<CategoryModel>> watchAllCategories() {
    try {
      return _firestore.collection(_collectionName).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final Map<String, dynamic> raw = doc.data();
          final data = {
            ...raw,
            'id': raw['id'] ?? doc.id,
          };
          return CategoryModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      return Stream.error('Failed to watch categories: $e');
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(categoryId).get();
      if (doc.exists && doc.data() != null) {
        final raw = doc.data()!;
        final data = {
          ...raw,
          'id': raw['id'] ?? doc.id,
        };
        return CategoryModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }

  @override
  Future<CategoryModel> updateCategory(String categoryId, CategoryModel category) async {
    try {
      final data = category.toJson();
      data.removeWhere((key, value) => value == null);
      await _firestore.collection(_collectionName).doc(categoryId).update(data);
      return category;
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }
}
