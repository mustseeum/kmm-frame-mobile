import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/questionnaire/question.dart';

part 'frame_questionnaire.g.dart';
@JsonSerializable()

class FrameQuestionnaire {
  final String formTitle;
  final String type;
  final String version;
  final int totalSteps;
  final List<Question> questions;

  FrameQuestionnaire({
    required this.formTitle,
    required this.type,
    required this.version,
    required this.totalSteps,
    required this.questions,
  });

  factory FrameQuestionnaire.fromJson(Map<String, dynamic> json) =>
      _$FrameQuestionnaireFromJson(json);

  Map<String, dynamic> toJson() => _$FrameQuestionnaireToJson(this);
}