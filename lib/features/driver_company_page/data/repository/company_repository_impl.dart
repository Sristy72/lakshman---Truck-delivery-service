import 'package:dio/dio.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/models/create_dispatcher_response.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/models/create_driver_response.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/domain/repository/company_repository.dart';

import '../../../../core/network/network_result.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<CreateDriverResponse> createDriver(FormData formData) {
    return _apiClient.post<CreateDriverResponse>(
      ApiConstants.company.createDriver,
      formData: formData,
      fromJsonT: (json) => CreateDriverResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<CreateDispatcherResponse> createDispatcher(FormData formData) {
    return _apiClient.post<CreateDispatcherResponse>(
      ApiConstants.company.createDispatcher,
      formData: formData,
      fromJsonT: (json) => CreateDispatcherResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<CreateDispatcherResponse> createDispatcherWithJson(Map<String, dynamic> data) {
    return _apiClient.post<CreateDispatcherResponse>(
      ApiConstants.company.createDispatcher,
      data: data,
      fromJsonT: (json) => CreateDispatcherResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
