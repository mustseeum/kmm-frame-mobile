// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/data_response/login/data_user.dart';
part 'login_data_model.g.dart';

@JsonSerializable()
class LoginDataModel {
  String? access_token;
  String? refresh_token;
  DataUser? user;

  LoginDataModel({this.access_token, this.refresh_token, this.user});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataModelToJson(this);
}
