import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/questionnaire/options.dart';
part 'question.g.dart';
@JsonSerializable()
class Question {
  final String id;
  final int step;
  final String question;
  final String type;
  final List<Options> options;

  Question({
    required this.id,
    required this.step,
    required this.question,
    required this.type,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}