// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentResponse _$ParentResponseFromJson(Map<String, dynamic> json) =>
    ParentResponse(
      code: (json['code'] as num?)?.toInt(),
      statusCode: (json['statusCode'] as num?)?.toInt(),
      status: json['status'] as bool?,
      responseTime: json['responseTime'] as String?,
      message: json['message'] as String?,
      data: json['data'],
      totalElement: (json['totalElement'] as num?)?.toInt(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ParentResponseToJson(ParentResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'responseTime': instance.responseTime,
      'totalElement': instance.totalElement,
      'totalPage': instance.totalPage,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
    };
