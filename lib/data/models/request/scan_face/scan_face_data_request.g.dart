// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_face_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanFaceDataRequest _$ScanFaceDataRequestFromJson(Map<String, dynamic> json) =>
    ScanFaceDataRequest(
      session_id: json['session_id'] as String?,
      looking_for: json['looking_for'] as String?,
      men_eyewear: json['men_eyewear'] as String?,
      gender_identity: json['gender_identity'] as String?,
    );

Map<String, dynamic> _$ScanFaceDataRequestToJson(
  ScanFaceDataRequest instance,
) => <String, dynamic>{
  'session_id': instance.session_id,
  'looking_for': instance.looking_for,
  'men_eyewear': instance.men_eyewear,
  'gender_identity': instance.gender_identity,
};
