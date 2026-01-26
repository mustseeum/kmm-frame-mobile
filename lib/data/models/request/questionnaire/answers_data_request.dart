import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers.dart';
part 'answers_data_request.g.dart';

@JsonSerializable()
class AnswersDataRequest {
  Answers? answers;
  @JsonKey(includeFromJson: false, includeToJson: false)
  File? image;

  AnswersDataRequest({
    this.answers,
    this.image,
  });

  factory AnswersDataRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswersDataRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AnswersDataRequestToJson(this);

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
