// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: json['id'] as String,
  step: (json['step'] as num).toInt(),
  question: json['question'] as String,
  type: json['type'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => Options.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'step': instance.step,
  'question': instance.question,
  'type': instance.type,
  'options': instance.options,
};
