// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurements_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementsDm _$MeasurementsDmFromJson(Map<String, dynamic> json) =>
    MeasurementsDm(
      bridge: (json['bridge'] as num?)?.toInt(),
      eye_height: (json['eye_height'] as num?)?.toInt(),
      eye_length_oicd: (json['eye_length_oicd'] as num?)?.toInt(),
      eye_width: (json['eye_width'] as num?)?.toInt(),
      face_width: (json['face_width'] as num?)?.toInt(),
      temple_length: (json['temple_length'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MeasurementsDmToJson(MeasurementsDm instance) =>
    <String, dynamic>{
      'bridge': instance.bridge,
      'eye_height': instance.eye_height,
      'eye_length_oicd': instance.eye_length_oicd,
      'eye_width': instance.eye_width,
      'face_width': instance.face_width,
      'temple_length': instance.temple_length,
    };
