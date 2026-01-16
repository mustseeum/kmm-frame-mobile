import 'package:json_annotation/json_annotation.dart';
part 'login_data_request.g.dart';

@JsonSerializable()
class LoginDataRequest {
  String? email;
  String? password;

  LoginDataRequest({this.email, this.password});

  factory LoginDataRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginDataRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataRequestToJson(this);
}
