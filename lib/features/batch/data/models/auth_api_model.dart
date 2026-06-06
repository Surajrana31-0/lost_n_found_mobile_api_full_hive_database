import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';

class AuthApiModel {
  final String? id;
  final String username;
  final String fullName;
  final String email;
  final String? phoneNumner;
  final String? password;
  final String? batchId;
  final String? profilePicture;
  final BatchApiModel? batch;

  AuthApiModel({
    this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.phoneNumner,
    this.password,
    this.batchId,
    this.profilePicture,
    this.batch,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "email": email,
      "phoneNumber": phoneNumner,
      "username": username,
      "password": password,
      "batchId": batchId,
      "profilePicture": profilePicture,
    };
  }

  //fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      fullName: json['name'] as String,
      email: json['email'] as String,
      phoneNumner: json['phoneNumber'] as String,
      batchId: json['batchId'] as String,
      profilePicture: json['profilePicture'] as String,
      batch: json['batch'] != null
          ? BatchApiModel.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
    );
  }

  //toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumner,
      batchId: batchId,
      profilePicture: profilePicture,
      batch: batch?.toEntity(),
    );
  }

  //fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      username: entity.username,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumner: entity.phoneNumber,
      batchId: entity.batchId,
      password: entity.password,
      profilePicture: entity.profilePicture,
      batch: entity.batch != null
          ? BatchApiModel.fromEntity(entity.batch!)
          : null,
    );
  }
  //toEntitytList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models){
    return models.map((model)=>model.toEntity()).toList();
  }
}
