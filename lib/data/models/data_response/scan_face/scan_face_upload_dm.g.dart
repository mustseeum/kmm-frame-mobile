// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_face_upload_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanFaceUploadDm _$ScanFaceUploadDmFromJson(Map<String, dynamic> json) =>
    ScanFaceUploadDm(
      answer: json['answer'] == null
          ? null
          : AnswerDm.fromJson(json['answer'] as Map<String, dynamic>),
      base64: json['base64'] as String?,
      expires_at: json['expires_at'] as String?,
      file_size: (json['file_size'] as num?)?.toInt(),
      filename: json['filename'] as String?,
      id: json['id'] as String?,
      mime_type: json['mime_type'] as String?,
      uploaded_at: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$ScanFaceUploadDmToJson(ScanFaceUploadDm instance) =>
    <String, dynamic>{
      'answer': instance.answer,
      'base64': instance.base64,
      'expires_at': instance.expires_at,
      'file_size': instance.file_size,
      'filename': instance.filename,
      'id': instance.id,
      'mime_type': instance.mime_type,
      'uploaded_at': instance.uploaded_at,
    };
