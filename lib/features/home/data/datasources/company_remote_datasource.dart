import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../models/company_model.dart';

abstract class CompanyRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<CompanyModel>>>> getAllCompanies();
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final ApiClient _apiClient;

  CompanyRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<CompanyModel>>>> getAllCompanies() async {
    try {
      DPrint.log("🚀 Fetching all companies from API...");
      
      final result = await _apiClient.get<List<CompanyModel>>(
        ApiConstants.company.getAllCompanies,
        fromJsonT: (json) {
          DPrint.log("📦 Raw Companies Response: $json");
          
          if (json is List) {
            return json.map((companyJson) => 
              CompanyModel.fromJson(companyJson as Map<String, dynamic>)
            ).toList();
          } else if (json is Map && json['data'] is List) {
            // Handle case where response is wrapped in a data object
            final companies = json['data'] as List;
            return companies.map((companyJson) => 
              CompanyModel.fromJson(companyJson as Map<String, dynamic>)
            ).toList();
          }
          
          // Fallback to empty list if structure is unexpected
          DPrint.log("⚠️ Unexpected response structure for companies");
          return <CompanyModel>[];
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch companies: ${failure.message}");
          return Left(failure);
        },
        (success) {
          final companies = success.data;
          DPrint.log("✅ Successfully fetched ${companies.length} companies");
          
          for (var company in companies) {
            DPrint.log("   - ${company.name} (${company.id}) - Default: ${company.isDefault}");
          }
          
          return Right(NetworkSuccess<List<CompanyModel>>(
            data: companies,
            message: 'Companies fetched successfully',
            statusCode: 200,
          ));
        },
      );
    } catch (e) {
      DPrint.error("💥 Unexpected error fetching companies: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to fetch companies: $e',
          statusCode: 0,
        ),
      );
    }
  }
}