// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_policies_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacyPoliciesDm _$PrivacyPoliciesDmFromJson(Map<String, dynamic> json) =>
    PrivacyPoliciesDm(
      id: json['id'] as String?,
      content: json['content'] as String?,
      language: json['language'] as String?,
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$PrivacyPoliciesDmToJson(PrivacyPoliciesDm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'language': instance.language,
      'created_at': instance.created_at,
    };
