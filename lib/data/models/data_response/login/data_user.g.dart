// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUser _$DataUserFromJson(Map<String, dynamic> json) => DataUser(
  uuid: json['uuid'] as String,
  employee_id: json['employee_id'] as String,
  email: json['email'] as String,
  employee_name: json['employee_name'] as String,
  role_id: json['role_id'] as String,
  role_name: json['role_name'] as String,
  role_code: json['role_code'] as String,
  store_id: (json['store_id'] as num).toInt(),
  store_name: json['store_name'] as String,
  store_code: json['store_code'] as String,
);

Map<String, dynamic> _$DataUserToJson(DataUser instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'employee_id': instance.employee_id,
  'email': instance.email,
  'employee_name': instance.employee_name,
  'role_id': instance.role_id,
  'role_name': instance.role_name,
  'role_code': instance.role_code,
  'store_id': instance.store_id,
  'store_name': instance.store_name,
  'store_code': instance.store_code,
};
