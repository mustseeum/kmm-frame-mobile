// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDataModel _$LoginDataModelFromJson(Map<String, dynamic> json) =>
    LoginDataModel(
      access_token: json['access_token'] as String?,
      refresh_token: json['refresh_token'] as String?,
      user: json['user'] == null
          ? null
          : DataUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginDataModelToJson(LoginDataModel instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'refresh_token': instance.refresh_token,
      'user': instance.user,
    };
