import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<CategoryModel>>>> getAllCategories() async {
    return await remoteDataSource.getAllCategories();
  }
}