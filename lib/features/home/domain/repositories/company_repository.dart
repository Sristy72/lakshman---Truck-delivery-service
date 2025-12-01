import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../data/models/company_model.dart';

abstract class CompanyRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<CompanyModel>>>> getAllCompanies();
}