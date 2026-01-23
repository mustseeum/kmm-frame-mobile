// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_result_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLResultDM _$MLResultDMFromJson(Map<String, dynamic> json) => MLResultDM(
  confidence_level: (json['confidence_level'] as num?)?.toDouble(),
  face_shape: json['face_shape'] as String?,
  image_id: json['image_id'] as String?,
  measurements: json['measurements'] == null
      ? null
      : MeasurementsDm.fromJson(json['measurements'] as Map<String, dynamic>),
  recommended_frames: json['recommended_frames'] == null
      ? null
      : RecommendedFramesDm.fromJson(
          json['recommended_frames'] as Map<String, dynamic>,
        ),
  session_id: json['session_id'] as String?,
  skin_tone: json['skin_tone'] as String?,
);

Map<String, dynamic> _$MLResultDMToJson(MLResultDM instance) =>
    <String, dynamic>{
      'confidence_level': instance.confidence_level,
      'face_shape': instance.face_shape,
      'image_id': instance.image_id,
      'measurements': instance.measurements,
      'recommended_frames': instance.recommended_frames,
      'session_id': instance.session_id,
      'skin_tone': instance.skin_tone,
    };
