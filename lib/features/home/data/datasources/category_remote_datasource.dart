import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<CategoryModel>>>> getAllCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<CategoryModel>>>> getAllCategories() async {
    try {
      DPrint.log("🚀 Fetching all categories from API...");
      
      final result = await _apiClient.get<List<CategoryModel>>(
        ApiConstants.category.getAllCategories,
        fromJsonT: (json) {
          DPrint.log("📦 Raw Categories Response: $json");
          
          if (json is List) {
            return json.map((categoryJson) => 
              CategoryModel.fromJson(categoryJson as Map<String, dynamic>)
            ).toList();
          } else if (json is Map && json['data'] is List) {
            // Handle case where response is wrapped in a data object
            final categories = json['data'] as List;
            return categories.map((categoryJson) => 
              CategoryModel.fromJson(categoryJson as Map<String, dynamic>)
            ).toList();
          }
          
          // Fallback to empty list if structure is unexpected
          DPrint.log("⚠️ Unexpected response structure for categories");
          return <CategoryModel>[];
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch categories: ${failure.message}");
          return Left(failure);
        },
        (success) {
          final categories = success.data;
          DPrint.log("✅ Successfully fetched ${categories.length} categories");
          
          for (var category in categories) {
            DPrint.log("   - ${category.name} (${category.id})");
          }
          
          return Right(NetworkSuccess<List<CategoryModel>>(
            data: categories,
            message: 'Categories fetched successfully',
            statusCode: 200,
          ));
        },
      );
    } catch (e) {
      DPrint.error("💥 Unexpected error fetching categories: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to fetch categories: $e',
          statusCode: 0,
        ),
      );
    }
  }
}