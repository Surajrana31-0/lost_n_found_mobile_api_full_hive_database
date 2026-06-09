import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/remote/item_remote_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

final itemRepositoryProvider = Provider<IItemRepository>((ref) {
  final itemLocalDatasource = ref.read(itemLocalDatasourceProvider);
  final itemRemoteDatasource = ref.read(itemRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ItemRepository(
    itemDatasource: itemLocalDatasource,
    itemRemoteDataSource: itemRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ItemRepository implements IItemRepository {
  final IItemLocalDataSource _itemDataSource;
  final IItemRemoteDataSource? _itemRemoteDataSource;
  final NetworkInfo _networkInfo;

  ItemRepository({
    required IItemLocalDataSource itemDatasource,
    IItemRemoteDataSource? itemRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _itemDataSource = itemDatasource,
       _itemRemoteDataSource = itemRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createItem(ItemEntity item) async {
    if (await _networkInfo.isConnected &&
        _itemRemoteDataSource != null) {
      try {
        final itemModel = ItemApiModel.fromEntity(item);
        final result = await _itemRemoteDataSource.createItem(itemModel);
        if (result) {
          // Optionally, we can also save the item locally after successful remote creation.
          final localItemModel = ItemHiveModel.fromEntity(item);
          await _itemDataSource.createItem(localItemModel);
          return const Right(true);
        }
        return const Left(
          ApiFailure(message: "Failed to create item on server"),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final itemModel = ItemHiveModel.fromEntity(item);
        final result = await _itemDataSource.createItem(itemModel);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to create item"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String itemId) async {
    try {
      final result = await _itemDataSource.deleteItem(itemId);
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to delete item"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    if (await _networkInfo.isConnected &&
        _itemRemoteDataSource != null) {
      try {
        final apiModels = await _itemRemoteDataSource.getAllItems();
        final hiveModels = apiModels
            .map((model) => ItemHiveModel.fromEntity(model.toEntity()))
            .toList();

        await _itemDataSource.syncItems(hiveModels);

        return Right(ItemApiModel.toEntityList(apiModels));
      } on DioException catch (e) {
        return _getLocalItemsOrFailure(
          ApiFailure(
            message:
                e.response?.data?['message']?.toString() ??
                e.message ??
                'Failed to fetch items from server',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return _getLocalItemsOrFailure(ApiFailure(message: e.toString()));
      }
    }

    return _getLocalItems();
  }

  Future<Either<Failure, List<ItemEntity>>> _getLocalItems() async {
    try {
      final models = await _itemDataSource.getAllItems();
      return Right(ItemHiveModel.toEntityList(models));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ItemEntity>>> _getLocalItemsOrFailure(
    Failure failure,
  ) async {
    final localResult = await _getLocalItems();

    return localResult.fold(
      (_) => Left(failure),
      (items) => items.isNotEmpty ? Right(items) : Left(failure),
    );
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String itemId) async {
    try {
      final model = await _itemDataSource.getItemById(itemId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: 'Item not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByUser(
    String userId,
  ) async {
    try {
      final models = await _itemDataSource.getItemsByUser(userId);
      final entities = ItemHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getLostItems() async {
    try {
      final models = await _itemDataSource.getLostItems();
      final entities = ItemHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getFoundItems() async {
    try {
      final models = await _itemDataSource.getFoundItems();
      final entities = ItemHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
    String categoryId,
  ) async {
    try {
      final models = await _itemDataSource.getItemsByCategory(categoryId);
      final entities = ItemHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateItem(ItemEntity item) async {
    try {
      final itemModel = ItemHiveModel.fromEntity(item);
      final result = await _itemDataSource.updateItem(itemModel);
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to update item"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async{
    //Image Remote ma matrai upload hunu parxha
    if ( await _networkInfo.isConnected ) {
      try{
        final fileName = await _itemRemoteDataSource!.uploadImage(image);
        return Right(fileName);
      }catch(e){
        return Left(ApiFailure(message: e.toString()));
       }
    }else{
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVideo(File video) async {
    //Video Remote ma matrai upload hunu parxha
    if ( await _networkInfo.isConnected ) {
      try{
        final fileName = await _itemRemoteDataSource!.uploadVideo(video);
        return Right(fileName);
      }catch(e){
        return Left(ApiFailure(message: e.toString()));
       }
    }else{
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }
}
