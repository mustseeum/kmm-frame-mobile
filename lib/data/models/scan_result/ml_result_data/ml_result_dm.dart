import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/face_shape_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/measurements_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/recommended_frames_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/skin_tone_dm.dart';
part 'ml_result_dm.g.dart';

@JsonSerializable()
class MLResultDM {
  double? confidence_level;
  FaceShapeDm? face_shape;
  String? image_id;
  MeasurementsDm? measurements;
  RecommendedFramesDm? recommended_frames;
  String? session_id;
  SkinToneDm? skin_tone;

  MLResultDM({
    this.confidence_level,
    this.face_shape,
    this.image_id,
    this.measurements,
    this.recommended_frames,
    this.session_id,
    this.skin_tone,
  });

  factory MLResultDM.fromJson(Map<String, dynamic> json) =>
      _$MLResultDMFromJson(json);
  Map<String, dynamic> toJson() => _$MLResultDMToJson(this);
}
