import 'package:json_annotation/json_annotation.dart';
part 'answer_dm.g.dart';

@JsonSerializable()
class AnswerDm {
  String? age_range;
  String? gender_identity;
  String? looking_for;

  AnswerDm({
    this.age_range,
    this.gender_identity,
    this.looking_for,
  });

  factory AnswerDm.fromJson(Map<String, dynamic> json) =>
      _$AnswerDmFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerDmToJson(this);
}