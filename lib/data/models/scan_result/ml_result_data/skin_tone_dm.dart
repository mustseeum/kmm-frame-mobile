import 'package:json_annotation/json_annotation.dart';
part 'skin_tone_dm.g.dart';

@JsonSerializable()
class SkinToneDm {
  int? id;
  String? label;

  SkinToneDm({this.id, this.label});

  factory SkinToneDm.fromJson(Map<String, dynamic> json) =>
      _$SkinToneDmFromJson(json);
  Map<String, dynamic> toJson() => _$SkinToneDmToJson(this);
}
