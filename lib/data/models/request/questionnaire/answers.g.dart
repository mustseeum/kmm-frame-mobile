// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answers _$AnswersFromJson(Map<String, dynamic> json) => Answers(
  session_id: json['session_id'] as String?,
  looking_for: json['looking_for'] as String?,
  age_range: json['age_range'] as String?,
  gender_identity: json['gender_identity'] as String?,
);

Map<String, dynamic> _$AnswersToJson(Answers instance) => <String, dynamic>{
  'session_id': instance.session_id,
  'looking_for': instance.looking_for,
  'age_range': instance.age_range,
  'gender_identity': instance.gender_identity,
};
