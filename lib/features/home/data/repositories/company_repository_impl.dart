import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_datasource.dart';
import '../models/company_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<CompanyModel>>>> getAllCompanies() async {
    return await remoteDataSource.getAllCompanies();
  }
}