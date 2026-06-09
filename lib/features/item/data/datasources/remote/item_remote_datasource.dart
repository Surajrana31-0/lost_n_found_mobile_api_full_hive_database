import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/core/services/storage/token_service.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';

final itemRemoteDatasourceProvider = Provider<ItemRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return ItemRemoteDatasource(apiClient, tokenService);
});

class ItemRemoteDatasource implements IItemRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  ItemRemoteDatasource(this._apiClient, this._tokenService);

  @override
  Future<bool> createItem(ItemApiModel item) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.items,
        data: item.toJson(),
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final createdItem = ItemApiModel.fromJson(data);
        return createdItem.id != null;
      }
      return false;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.items}/$itemId');
      return response.statusCode == 200;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<ItemApiModel>> getAllItems() async {
    final response = await _apiClient.get(ApiEndpoints.items);

    if (response.data['success'] == true) {
      final data = response.data['data'];
      if (data is! List) return [];

      return data
          .map((item) => ItemApiModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: response.data['message'] ?? 'Failed to fetch items',
    );
  }

  @override
  Future<List<ItemApiModel>> getFoundItems() {
    throw UnimplementedError();
  }

  @override
  Future<ItemApiModel?> getItemById(String itemId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getItemsByCategory(String categoryId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getItemsByUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getLostItems() {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateItem(ItemApiModel item) {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(File image) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'filePhoto': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    //got token from tkoen service or secure storage
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData:formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data['data'];
  }

  @override
  Future<String> uploadVideo(File video) async {
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'fileVideo': MultipartFile.fromFile(video.path, filename: fileName),
    });
    //got token from tkoen service or secure storage
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadVideo,
      formData:formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data['success'];
  }
}
