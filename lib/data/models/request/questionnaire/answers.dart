import 'package:json_annotation/json_annotation.dart';
part 'answers.g.dart';

@JsonSerializable()
class Answers {
  String? session_id;
  String? looking_for;
  String? age_range;
  String? gender_identity;

  Answers({
    this.session_id,
    this.looking_for,
    this.age_range,
    this.gender_identity,
  });

  factory Answers.fromJson(Map<String, dynamic> json) =>
      _$AnswersFromJson(json);
  Map<String, dynamic> toJson() => _$AnswersToJson(this);
}
