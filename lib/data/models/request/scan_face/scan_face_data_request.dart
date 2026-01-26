import 'package:json_annotation/json_annotation.dart';
part 'scan_face_data_request.g.dart';

@JsonSerializable()
class ScanFaceDataRequest {
  String? session_id;
  String? looking_for;
  String? men_eyewear;
  String? gender_identity;

  ScanFaceDataRequest({
    this.session_id,
    this.looking_for,
    this.men_eyewear,
    this.gender_identity,
  });

  factory ScanFaceDataRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanFaceDataRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ScanFaceDataRequestToJson(this);
}
