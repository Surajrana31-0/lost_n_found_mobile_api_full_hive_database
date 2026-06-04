import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

class BatchApiModel {
  final String? id;
  final String batchName;
  final String? status;

  BatchApiModel({this.id, required this.batchName, this.status});

  //From Json
  factory BatchApiModel.fromJson(Map<String, dynamic> json) {
    return BatchApiModel(
      id: json['_id'] as String?,
      batchName: json['batchName'] as String,
      status: json['status'] as String?,
    );
  }

  //To Json
  Map<String, dynamic> toJson() {
    return {'batchName': batchName};
  }

  //To Entity
  BatchEntity toEntity() {
    return BatchEntity(batchId: id, batchName: batchName, status: status);
  }

  // //From entity
  // factory BatchApiModel.fromEntity(BatchEntity entity){
  //   return BatchApiModel(batchId: id,batchName: batchName, status: status)
  // }
}
