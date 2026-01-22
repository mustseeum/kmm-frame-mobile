// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswersDataRequest _$AnswersDataRequestFromJson(Map<String, dynamic> json) =>
    AnswersDataRequest(
      answers: json['answers'] == null
          ? null
          : Answers.fromJson(json['answers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnswersDataRequestToJson(AnswersDataRequest instance) =>
    <String, dynamic>{'answers': instance.answers};
