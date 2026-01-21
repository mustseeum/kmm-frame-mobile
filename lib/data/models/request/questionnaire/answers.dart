import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
part 'answers.g.dart';

@JsonSerializable()
class Answers {
  String? session_id;
  String? looking_for;
  String? age_range;
  String? gender_identity;

  @JsonKey(includeFromJson: false, includeToJson: false)
  File? image;

  Answers({
    this.session_id,
    this.looking_for,
    this.age_range,
    this.gender_identity,
    this.image,
  });

  factory Answers.fromJson(Map<String, dynamic> json) =>
      _$AnswersFromJson(json);
  Map<String, dynamic> toJson() => _$AnswersToJson(this);

  Future<FormData> toFormData() async {
    final Map<String, dynamic> jsonMap = toJson();

    final formMap = {
      ...jsonMap,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    };

    return FormData.fromMap(formMap);
  }
}
