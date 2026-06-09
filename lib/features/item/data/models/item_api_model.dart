import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

class ItemApiModel {
  final String? id;
  final String itemName;
  final String? description;
  final String type;
  final String location;
  final String? category;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? claimedBy;
  final String? reportedBy;
  final String? status;

  ItemApiModel({
    this.id,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.category,
    this.media,
    this.mediaType,
    required this.isClaimed,
    this.reportedBy,
    this.claimedBy,
    this.status,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'description': description,
      'type': type,
      'location': location,
      'category': category,
      'media': media,
      'mediaType': mediaType,
      'isClaimed': isClaimed,
      'claimedBy': claimedBy,
      'status': status,
    };
  }


  //fromJson
  factory ItemApiModel.fromJson(Map<String, dynamic> json) {
    return ItemApiModel(
      id: json['id'] as String?,
      itemName: json['itemName'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      location: json['location'] as String,
      category: json['category'] as String?,
      media: json['media'] as String,
      mediaType: json['mediaType'] as String,
      isClaimed: json['isClaimed'] ?? false,
      claimedBy: json['claimedBy'] as String?,
      reportedBy: json['reportedBy'] as String?,
      status: json['status'] as String,
    );
  }

  // toEntity
  ItemEntity toEntity() { 
    return ItemEntity(
      itemId: id,
      itemName: itemName,
      description: description,
      type: type == 'lost' ? ItemType.lost : ItemType.found,
      location: location,
      categoryId: category,
      media: media,
      mediaType: mediaType,
      isClaimed: isClaimed,
      claimedBy: claimedBy,
      reportedBy: reportedBy,
      status: status,
    );
  }

  //fromEntity
  factory ItemApiModel.fromEntity(ItemEntity entity) {
    return ItemApiModel(
      id: entity.itemId,
      itemName: entity.itemName,
      description: entity.description,
      type: entity.type == ItemType.lost ? 'lost' : 'found',
      location: entity.location,
      category: entity.categoryId,
      media: entity.media,
      mediaType: entity.mediaType,
      isClaimed: entity.isClaimed,
      claimedBy: entity.claimedBy,
      reportedBy: entity.reportedBy,
      status: entity.status,
    );
  }
  //toEntityList
  static List<ItemEntity> toEntityList(List<ItemApiModel> apiModels) {
    return apiModels.map((apiModel) => apiModel.toEntity()).toList();
  }
}
