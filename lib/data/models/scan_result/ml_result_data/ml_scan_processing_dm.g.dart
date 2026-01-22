// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_scan_processing_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLScanProcessingDm _$MLScanProcessingDmFromJson(Map<String, dynamic> json) =>
    MLScanProcessingDm(
      image_id: json['image_id'] as String?,
      ml_result: json['ml_result'] == null
          ? null
          : MLResultDM.fromJson(json['ml_result'] as Map<String, dynamic>),
      session_id: json['session_id'] as String?,
    );

Map<String, dynamic> _$MLScanProcessingDmToJson(MLScanProcessingDm instance) =>
    <String, dynamic>{
      'image_id': instance.image_id,
      'ml_result': instance.ml_result,
      'session_id': instance.session_id,
    };
