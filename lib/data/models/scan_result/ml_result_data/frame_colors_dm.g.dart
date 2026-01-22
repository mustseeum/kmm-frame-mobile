// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_colors_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorsDm _$ColorsDmFromJson(Map<String, dynamic> json) => ColorsDm(
  frame_color_id: (json['frame_color_id'] as num?)?.toInt(),
  frame_color_name: json['frame_color_name'] as String?,
  score: (json['score'] as num?)?.toInt(),
);

Map<String, dynamic> _$ColorsDmToJson(ColorsDm instance) => <String, dynamic>{
  'frame_color_id': instance.frame_color_id,
  'frame_color_name': instance.frame_color_name,
  'score': instance.score,
};
