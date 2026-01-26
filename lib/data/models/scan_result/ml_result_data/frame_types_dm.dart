import 'package:json_annotation/json_annotation.dart';
part 'frame_types_dm.g.dart';

@JsonSerializable()
class FrameTypesDm {
  int? frame_type_id;
  String? frame_type_name;
  int? score;

  FrameTypesDm({this.frame_type_id, this.frame_type_name, this.score});

  factory FrameTypesDm.fromJson(Map<String, dynamic> json) =>
      _$FrameTypesDmFromJson(json);
  Map<String, dynamic> toJson() => _$FrameTypesDmToJson(this);
}
