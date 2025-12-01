import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<CategoryModel>>>> getAllCategories();
}