import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_result_data.dart';
part 'ml_result_dm.g.dart';

@JsonSerializable()
class MLResultDM {
  MlResultData? data;

  MLResultDM({
    this.data,
  });

  factory MLResultDM.fromJson(Map<String, dynamic> json) =>
      _$MLResultDMFromJson(json);
  Map<String, dynamic> toJson() => _$MLResultDMToJson(this);
}
