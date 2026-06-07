import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';

//Provider for ItemRemoteDatasource
final itemRemoteDatasourceProvider = Provider<ItemRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ItemRemoteDatasource(apiClient);
});

class ItemRemoteDatasource implements IItemRemoteDataSource {
  final ApiClient _apiClient;
  ItemRemoteDatasource(this._apiClient);

  @override
  Future<bool> createItem(ItemApiModel item) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.items,
        data: item.toJson(),
      );
      if(response.data['success'] == true){
        final data = response.data['data'] as Map<String, dynamic>;
        final createdItem = ItemApiModel.fromJson(data);
        return createdItem.id != null; // Return true if item was created successfully, false otherwise.
      }
      return item.id != null; // Return true if item was created successfully, false otherwise.
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.items}/$itemId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ItemApiModel>> getAllItems() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.items);
      if (response.data['success'] == true) {
        final items = (response.data['data'] as List)
            .map((item) => ItemApiModel.fromJson(item))
            .toList();
        return items;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemApiModel>> getFoundItems() {
    // TODO: implement getFoundItems
    throw UnimplementedError();
  }

  @override
  Future<ItemApiModel?> getItemById(String itemId) {
    // TODO: implement getItemById
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getItemsByCategory(String categoryId) {
    // TODO: implement getItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getItemsByUser(String userId) {
    // TODO: implement getItemsByUser
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getLostItems() {
    // TODO: implement getLostItems
    throw UnimplementedError();
  }

  @override
  Future<bool> updateItem(ItemApiModel item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }
}
