import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/measurements_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/recommended_frames_dm.dart';
part 'ml_result_data.g.dart';

@JsonSerializable()
class MlResultData {
  double? confidence_level;
  String? face_shape;
  String? image_id;
  MeasurementsDm? measurements;
  RecommendedFramesDm? recommended_frames;
  String? session_id;
  String? skin_tone;

  MlResultData({
    this.confidence_level,
    this.face_shape,
    this.image_id,
    this.measurements,
    this.recommended_frames,
    this.session_id,
    this.skin_tone,
  });

  factory MlResultData.fromJson(Map<String, dynamic> json) =>
      _$MlResultDataFromJson(json);
  Map<String, dynamic> toJson() => _$MlResultDataToJson(this);
}