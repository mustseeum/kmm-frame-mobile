// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionDm _$SessionDmFromJson(Map<String, dynamic> json) => SessionDm(
  user_name: json['user_name'] as String?,
  activity_type: json['activity_type'] as String?,
  created_at: json['created_at'] as String?,
  duration_minutes: (json['duration_minutes'] as num?)?.toInt(),
  ended_at: json['ended_at'] as String?,
  last_activity_at: json['last_activity_at'] as String?,
  result_data: json['result_data'] == null
      ? null
      : ResultData.fromJson(json['result_data'] as Map<String, dynamic>),
  session_id: json['session_id'] as String?,
  started_at: json['started_at'] as String?,
  status: json['status'] as String?,
  store_code: json['store_code'] as String?,
  store_id: (json['store_id'] as num?)?.toInt(),
  store_name: json['store_name'] as String?,
  timeout_duration_minutes: (json['timeout_duration_minutes'] as num?)?.toInt(),
  updated_at: json['updated_at'] as String?,
  user_email: json['user_email'] as String?,
  user_id: json['user_id'] as String?,
);

Map<String, dynamic> _$SessionDmToJson(SessionDm instance) => <String, dynamic>{
  'activity_type': instance.activity_type,
  'created_at': instance.created_at,
  'duration_minutes': instance.duration_minutes,
  'ended_at': instance.ended_at,
  'last_activity_at': instance.last_activity_at,
  'result_data': instance.result_data,
  'session_id': instance.session_id,
  'started_at': instance.started_at,
  'status': instance.status,
  'store_code': instance.store_code,
  'store_id': instance.store_id,
  'store_name': instance.store_name,
  'timeout_duration_minutes': instance.timeout_duration_minutes,
  'updated_at': instance.updated_at,
  'user_email': instance.user_email,
  'user_id': instance.user_id,
  'user_name': instance.user_name,
};
