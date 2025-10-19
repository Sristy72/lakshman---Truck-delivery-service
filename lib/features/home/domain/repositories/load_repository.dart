import '../../../../core/network/network_result.dart';
import '../entities/load_entity.dart';

abstract class LoadRepository {
  NetworkResult<List<LoadEntity>> getLoads();
}
