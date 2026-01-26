// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'data_user.g.dart';

@JsonSerializable()
class DataUser {
  String? email;
  String? employee_id;
  String? employee_name;
  String? role_code;
  String? role_id;
  String? role_name;
  String? store_code;
  int? store_id;
  String? store_name;
  String? store_address;
  String? store_phone;
  String? uuid;

  DataUser({
    this.email,
    this.employee_id,
    this.employee_name,
    this.role_code,
    this.role_id,
    this.role_name,
    this.store_code,
    this.store_id,
    this.store_name,
    this.store_address,
    this.store_phone,
    this.uuid,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) =>
      _$DataUserFromJson(json);

  Map<String, dynamic> toJson() => _$DataUserToJson(this);
}
