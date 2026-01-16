// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'data_user.g.dart';

@JsonSerializable()
class DataUser {
  final String uuid;
  final String employee_id;
  final String email;
  final String employee_name;
  final String role_id;
  final String role_name;
  final String role_code;
  final int store_id;
  final String store_name;
  final String store_code;

  DataUser({
    required this.uuid,
    required this.employee_id,
    required this.email,
    required this.employee_name,
    required this.role_id,
    required this.role_name,
    required this.role_code,
    required this.store_id,
    required this.store_name,
    required this.store_code,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) =>
      _$DataUserFromJson(json);

  Map<String, dynamic> toJson() => _$DataUserToJson(this);
}
