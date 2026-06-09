import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

//Provider
final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UploadPhotoUsecase(itemRepository);
});

class  UploadPhotoUsecase implements UsecaseWithParms<String, File> {
  final IItemRepository _itemRepository;
  UploadPhotoUsecase(this._itemRepository);

  @override
  Future<Either<Failure, String>> call(File parms){
    return _itemRepository.uploadImage(parms);
  }
  
}