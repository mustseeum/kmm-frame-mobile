import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/frame_colors_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/frame_types_dm.dart';
part 'recommended_frames_dm.g.dart';

@JsonSerializable()
class RecommendedFramesDm {
  List<ColorsDm>? colors;
  List<FrameTypesDm>? types;

  RecommendedFramesDm({this.colors, this.types});

  factory RecommendedFramesDm.fromJson(Map<String, dynamic> json) =>
      _$RecommendedFramesDmFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendedFramesDmToJson(this);
}
