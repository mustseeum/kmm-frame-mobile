// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentResponse _$ParentResponseFromJson(Map<String, dynamic> json) =>
    ParentResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ParentResponseToJson(ParentResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'error': instance.error,
    };
