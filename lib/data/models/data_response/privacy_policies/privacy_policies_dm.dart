import 'package:json_annotation/json_annotation.dart';
part 'privacy_policies_dm.g.dart';

@JsonSerializable()
class PrivacyPoliciesDm {
  String? id;
  String? content;
  String? language;
  String? created_at;

  PrivacyPoliciesDm({this.id, this.content, this.language, this.created_at});

  factory PrivacyPoliciesDm.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPoliciesDmFromJson(json);
  Map<String, dynamic> toJson() => _$PrivacyPoliciesDmToJson(this);
}
