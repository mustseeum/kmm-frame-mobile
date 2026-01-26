import 'package:json_annotation/json_annotation.dart';
part 'measurements_dm.g.dart';

@JsonSerializable()
class MeasurementsDm {
  int? bridge;
  int? eye_height;
  int? eye_length_oicd;
  int? eye_width;
  int? face_width;
  int? temple_length;

  MeasurementsDm({
    this.bridge,
    this.eye_height,
    this.eye_length_oicd,
    this.eye_width,
    this.face_width,
    this.temple_length,
  });

  factory MeasurementsDm.fromJson(Map<String, dynamic> json) =>
      _$MeasurementsDmFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementsDmToJson(this);
}
