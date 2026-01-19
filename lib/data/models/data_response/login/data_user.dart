// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'data_user.g.dart';

@JsonSerializable()
class DataUser {
  String? uuid;
  String? employee_id;
  String? email;
  String? employee_name;
  String? role_id;
  String? role_name;
  String? role_code;
  int? store_id;
  String? store_name;
  String? store_code;

  DataUser({
    this.uuid,
    this.employee_id,
    this.email,
    this.employee_name,
    this.role_id,
    this.role_name,
    this.role_code,
    this.store_id,
    this.store_name,
    this.store_code,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) =>
      _$DataUserFromJson(json);

  Map<String, dynamic> toJson() => _$DataUserToJson(this);
}
