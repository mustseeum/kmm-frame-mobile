import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/questionnaire/question.dart';

part 'lens_questionnaire.g.dart';
@JsonSerializable()

class LensQuestionnaire {
  final String formTitle;
  final String type;
  final String version;
  final int totalSteps;
  final List<Question> questions;

  LensQuestionnaire({
    required this.formTitle,
    required this.type,
    required this.version,
    required this.totalSteps,
    required this.questions,
  });

  factory LensQuestionnaire.fromJson(Map<String, dynamic> json) =>
      _$LensQuestionnaireFromJson(json);

  Map<String, dynamic> toJson() => _$LensQuestionnaireToJson(this);
}