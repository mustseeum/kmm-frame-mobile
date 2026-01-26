import 'package:json_annotation/json_annotation.dart';
part 'frame_colors_dm.g.dart';

@JsonSerializable()
class ColorsDm {
  int? frame_color_id;
  String? frame_color_name;
  int? score;

  ColorsDm({this.frame_color_id, this.frame_color_name, this.score});

  factory ColorsDm.fromJson(Map<String, dynamic> json) =>
      _$ColorsDmFromJson(json);
  Map<String, dynamic> toJson() => _$ColorsDmToJson(this);
}
