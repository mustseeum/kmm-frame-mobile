import 'package:json_annotation/json_annotation.dart';
part 'face_shape_dm.g.dart';

@JsonSerializable()
class FaceShapeDm {
  int? id;
  String? label;

  FaceShapeDm({this.id, this.label});

  factory FaceShapeDm.fromJson(Map<String, dynamic> json) =>
      _$FaceShapeDmFromJson(json);
  Map<String, dynamic> toJson() => _$FaceShapeDmToJson(this);
}
