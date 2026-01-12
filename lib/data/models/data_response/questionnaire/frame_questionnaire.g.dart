// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameQuestionnaire _$FrameQuestionnaireFromJson(Map<String, dynamic> json) =>
    FrameQuestionnaire(
      formTitle: json['formTitle'] as String,
      type: json['type'] as String,
      version: json['version'] as String,
      totalSteps: (json['totalSteps'] as num).toInt(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FrameQuestionnaireToJson(FrameQuestionnaire instance) =>
    <String, dynamic>{
      'formTitle': instance.formTitle,
      'type': instance.type,
      'version': instance.version,
      'totalSteps': instance.totalSteps,
      'questions': instance.questions,
    };
