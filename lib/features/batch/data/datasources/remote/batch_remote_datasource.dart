

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';


//Provider
final batchRemoteDataSourceProvider = Provider<IBatchRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BatchRemoteDatasource(apiClient: apiClient);
});


class BatchRemoteDatasource implements IBatchRemoteDataSource {
  final ApiClient _apiClient;

  BatchRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createBatch(BatchApiModel batch) async{
    final response = await _apiClient.post(ApiEndpoints.batches, data:batch);
    return response.data['success'] == true;
  }

  @override
  Future<List<BatchApiModel>> getAllBatches() async{
    final response = await _apiClient.get(ApiEndpoints.batches);
    final data = response.data['data'] as List;
    return data.map((json)=> BatchApiModel.fromJson(json)).toList();
    //json => api model => entity:fromJson => toEntity
    //entity => api model => json:tojson =>
  }

  @override
  Future<BatchApiModel?> getBatchById(String batchId) async {
    final response = await _apiClient.get(ApiEndpoints.batchById(batchId));
    return BatchApiModel.fromJson(response.data['data']);
  }
  
  @override
  Future<bool> updateBatch(BatchApiModel batch) async {
    final response = await _apiClient.put(ApiEndpoints.batchById(batch.id!), data: batch.toJson()); 
    return Future.value(response.data['success'] as bool);

  }

  
  
}
