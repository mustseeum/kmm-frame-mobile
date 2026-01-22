import 'package:json_annotation/json_annotation.dart';
import 'ml_result_dm.dart';
part 'ml_scan_processing_dm.g.dart';

@JsonSerializable()
class MLScanProcessingDm {
  String? image_id;
  MLResultDM? ml_result;
  String? session_id;

  MLScanProcessingDm({this.image_id, this.ml_result, this.session_id});

  factory MLScanProcessingDm.fromJson(Map<String, dynamic> json) =>
      _$MLScanProcessingDmFromJson(json);
  Map<String, dynamic> toJson() => _$MLScanProcessingDmToJson(this);
}
