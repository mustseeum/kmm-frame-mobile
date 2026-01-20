import 'package:json_annotation/json_annotation.dart';
part 'session_data_request.g.dart';

@JsonSerializable()
class SessionDataRequest {
  String? activity_type;

  SessionDataRequest({this.activity_type});

  factory SessionDataRequest.fromJson(Map<String, dynamic> json) =>
      _$SessionDataRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDataRequestToJson(this);
}