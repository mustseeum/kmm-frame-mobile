import 'package:json_annotation/json_annotation.dart';
part 'result_data.g.dart';

@JsonSerializable()
class ResultData {
  Map<String, dynamic>? additionalProp1;

  ResultData({this.additionalProp1});

  factory ResultData.fromJson(Map<String, dynamic> json) =>
      _$ResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDataToJson(this);
}
