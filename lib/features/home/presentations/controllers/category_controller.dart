import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../data/models/category_model.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository;

  CategoryController({required CategoryRepository repository})
      : _repository = repository;

  // Observable lists
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch on init to avoid unnecessary API calls
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log("========== FETCH CATEGORIES ==========");

      final result = await _repository.getAllCategories();

      result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch categories: ${failure.message}");
          errorMessage.value = failure.message;
          categories.clear();
        },
        (success) {
          DPrint.log("✅ Successfully fetched ${success.data.length} categories");
          categories.value = success.data;
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("💥 Unexpected error in CategoryController: $e");
      errorMessage.value = 'An unexpected error occurred';
      categories.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Get category by ID
  CategoryModel? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get category names for dropdown (unique names only)
  List<String> get categoryNames {
    final uniqueNames = <String>{};
    final names = <String>[];
    
    for (var category in categories) {
      if (!uniqueNames.contains(category.name)) {
        uniqueNames.add(category.name);
        names.add(category.name);
      }
    }
    
    return names;
  }

  /// Get display names with ID for dropdown (to handle duplicates)
  List<Map<String, String>> get categoryDisplayItems {
    final Map<String, int> nameCount = {};
    final List<Map<String, String>> items = [];
    
    // First pass: count occurrences of each name
    for (var category in categories) {
      nameCount[category.name] = (nameCount[category.name] ?? 0) + 1;
    }
    
    // Second pass: create display names
    final Map<String, int> nameIndex = {};
    for (var category in categories) {
      final baseLabel = category.name;
      String displayLabel = baseLabel;
      
      if (nameCount[baseLabel]! > 1) {
        nameIndex[baseLabel] = (nameIndex[baseLabel] ?? 0) + 1;
        displayLabel = '$baseLabel (${category.id.substring(category.id.length - 4)})';
      }
      
      items.add({
        'id': category.id,
        'name': category.name,
        'display': displayLabel,
      });
    }
    
    return items;
  }

  /// Get category ID by name
  String? getCategoryIdByName(String name) {
    try {
      final category = categories.firstWhere((category) => category.name == name);
      return category.id;
    } catch (e) {
      return null;
    }
  }
}