// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_types_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameTypesDm _$FrameTypesDmFromJson(Map<String, dynamic> json) => FrameTypesDm(
  frame_type_id: (json['frame_type_id'] as num?)?.toInt(),
  frame_type_name: json['frame_type_name'] as String?,
  score: (json['score'] as num?)?.toInt(),
);

Map<String, dynamic> _$FrameTypesDmToJson(FrameTypesDm instance) =>
    <String, dynamic>{
      'frame_type_id': instance.frame_type_id,
      'frame_type_name': instance.frame_type_name,
      'score': instance.score,
    };
