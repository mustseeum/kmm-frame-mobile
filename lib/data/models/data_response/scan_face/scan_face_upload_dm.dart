import 'package:kacamatamoo/data/models/data_response/scan_face/answer_dm.dart';
import 'package:json_annotation/json_annotation.dart';
part 'scan_face_upload_dm.g.dart';

@JsonSerializable()
class ScanFaceUploadDm {
  AnswerDm? answer;
  String? base64;
  String? expires_at;
  int? file_size;
  String? filename;
  String? id;
  String? mime_type;
  String? uploaded_at;

  ScanFaceUploadDm({
    this.answer,
    this.base64,
    this.expires_at,
    this.file_size,
    this.filename,
    this.id,
    this.mime_type,
    this.uploaded_at,
  });

  factory ScanFaceUploadDm.fromJson(Map<String, dynamic> json) =>
      _$ScanFaceUploadDmFromJson(json);
  Map<String, dynamic> toJson() => _$ScanFaceUploadDmToJson(this);
}
