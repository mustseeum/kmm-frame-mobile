// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_frames_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedFramesDm _$RecommendedFramesDmFromJson(Map<String, dynamic> json) =>
    RecommendedFramesDm(
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => ColorsDm.fromJson(e as Map<String, dynamic>))
          .toList(),
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => FrameTypesDm.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendedFramesDmToJson(
  RecommendedFramesDm instance,
) => <String, dynamic>{'colors': instance.colors, 'types': instance.types};
