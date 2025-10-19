import 'package:dartz/dartz.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/entities/load_entity.dart';
import '../../domain/repositories/load_repository.dart';
import '../datasources/load_remote_datasource.dart';

class LoadRepositoryImpl implements LoadRepository {
  final LoadRemoteDataSource remoteDataSource;

  LoadRepositoryImpl({required this.remoteDataSource});

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
}
