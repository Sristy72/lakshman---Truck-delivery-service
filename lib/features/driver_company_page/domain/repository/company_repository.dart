import 'package:dio/dio.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/models/create_dispatcher_response.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/models/create_driver_response.dart';

import '../../../../core/network/network_result.dart';

abstract class CompanyRepository {
  NetworkResult<CreateDriverResponse> createDriver(FormData formData);
  NetworkResult<CreateDispatcherResponse> createDispatcher(FormData formData);
  NetworkResult<CreateDispatcherResponse> createDispatcherWithJson(Map<String, dynamic> data);
}
