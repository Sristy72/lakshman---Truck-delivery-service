import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../models/load_model.dart';

abstract class LoadRemoteDataSource {
  Future<List<LoadModel>> getLoads();
  Future<List<LoadModel>> getLoadsByCompany(String companyId);
}

class LoadRemoteDataSourceImpl implements LoadRemoteDataSource {
  final ApiClient apiClient;

  LoadRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<LoadModel>> getLoads() async {
    final response = await apiClient.get<List<dynamic>>(
      ApiConstants.load.getLoads,
      fromJsonT: (json) {
        // json here is already the 'data' field which is a List
        return json as List<dynamic>;
      },
    );

    return response.fold((failure) => throw failure, (success) {
      final data = success.data;
      return data
          .map((json) => LoadModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<LoadModel>> getLoadsByCompany(String companyId) async {
    final response = await apiClient.get<List<dynamic>>(
      ApiConstants.load.getLoads,
      queryParameters: {'company': companyId},
      fromJsonT: (json) {
        // json here is already the 'data' field which is a List
        return json as List<dynamic>;
      },
    );

    return response.fold((failure) => throw failure, (success) {
      final data = success.data;
      return data
          .map((json) => LoadModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }
}
