// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_result_dm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLResultDM _$MLResultDMFromJson(Map<String, dynamic> json) => MLResultDM(
  data: json['data'] == null
      ? null
      : MlResultData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MLResultDMToJson(MLResultDM instance) =>
    <String, dynamic>{'data': instance.data};
