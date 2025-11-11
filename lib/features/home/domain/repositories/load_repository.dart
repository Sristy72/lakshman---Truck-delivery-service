import 'package:flutter_lakshman1020/features/home/data/models/get_dispatcher_by_id.dart';

import '../../../../core/network/network_result.dart';
import '../entities/load_entity.dart';

abstract class LoadRepository {
  NetworkResult<List<LoadEntity>> getLoads();
  /// Fetch a single load by id
  Future<LoadEntity> getLoadById(String id);

  /// Create or post a new load
  Future<LoadEntity> createLoad(Map<String, dynamic> payload);
  
  /// Get loads filtered by company ID
  Future<List<LoadEntity>> getLoadsByCompany(String companyId);

  NetworkResult<DispatcherByIdResponseModel> getLoadDispatcherById(String id);
}
