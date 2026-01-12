// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LensQuestionnaire _$LensQuestionnaireFromJson(Map<String, dynamic> json) =>
    LensQuestionnaire(
      formTitle: json['formTitle'] as String,
      type: json['type'] as String,
      version: json['version'] as String,
      totalSteps: (json['totalSteps'] as num).toInt(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LensQuestionnaireToJson(LensQuestionnaire instance) =>
    <String, dynamic>{
      'formTitle': instance.formTitle,
      'type': instance.type,
      'version': instance.version,
      'totalSteps': instance.totalSteps,
      'questions': instance.questions,
    };
