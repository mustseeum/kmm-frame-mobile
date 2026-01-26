import 'package:json_annotation/json_annotation.dart';
part 'parent_response.g.dart';

@JsonSerializable()
class ParentResponse {
  bool? success;
  String? message;
  dynamic data;
  String? error;

  ParentResponse({
    this.success,
    this.message,
    this.data,
    this.error,
  });

  factory ParentResponse.fromJson(Map<String, dynamic> json) =>
      _$ParentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParentResponseToJson(this);
}
