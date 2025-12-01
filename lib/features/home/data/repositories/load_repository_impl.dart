import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/entities/load_entity.dart';
import '../../domain/repositories/load_repository.dart';
import '../datasources/load_remote_datasource.dart';
import '../models/load_model.dart';

class LoadRepositoryImpl implements LoadRepository {
  final LoadRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  LoadRepositoryImpl({
    required this.remoteDataSource,
    required this.apiClient,
  });

  @override
  NetworkResult<List<LoadEntity>> getLoads() async {
    try {
      final loads = await remoteDataSource.getLoads();
      return Right(
        NetworkSuccess(
          data: loads,
          message: 'Loads retrieved successfully',
          statusCode: 200,
        ),
      );
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<LoadEntity> getLoadById(String id) async {
    final endpoint = ApiConstants.load.getById(id);

    final result = await apiClient.get<LoadModel>(
      endpoint,
      fromJsonT: (json) => LoadModel.fromJson(json as Map<String, dynamic>),
    );

    return result.fold(
      (failure) {
        throw Exception('Failed to fetch load: ${failure.runtimeType}');
      },
      (success) {
        return success.data;
      },
    );
  }

  @override
  Future<LoadEntity> createLoad(Map<String, dynamic> payload) async {
    final endpoint = ApiConstants.load.getLoads;

    final result = await apiClient.post<LoadModel>(
      endpoint,
      data: payload,
      fromJsonT: (json) => LoadModel.fromJson(json as Map<String, dynamic>),
    );

    return result.fold(
      (failure) {
        throw Exception('Failed to create load: ${failure.runtimeType}');
      },
      (success) {
        return success.data;
      },
    );
  }

  @override
  Future<List<LoadEntity>> getLoadsByCompany(String companyId) async {
    try {
      final loads = await remoteDataSource.getLoadsByCompany(companyId);
      return loads;
    } catch (e) {
      throw Exception('Failed to fetch company loads: $e');
    }
  }
}
