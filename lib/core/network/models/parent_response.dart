import 'package:json_annotation/json_annotation.dart';
part 'parent_response.g.dart';

@JsonSerializable()
class ParentResponse {
  int? code;
  int? statusCode;
  bool? status;
  String? message;
  dynamic data;
  String? responseTime;
  int? totalElement;
  int? totalPage;
  int? currentPage;
  int? pageSize;

  ParentResponse({
    this.code,
    this.statusCode,
    this.status,
    this.responseTime,
    this.message,
    this.data,
    this.totalElement,
    this.totalPage,
    this.currentPage,
    this.pageSize,
  });

  factory ParentResponse.fromJson(Map<String, dynamic> json) =>
      _$ParentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParentResponseToJson(this);
}
