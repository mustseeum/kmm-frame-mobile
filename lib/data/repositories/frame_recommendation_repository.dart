import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kacamatamoo/data/json_question/frame_recommendation.dart';
import 'package:kacamatamoo/data/models/questionnaire/frame_questionnaire.dart';
import 'package:kacamatamoo/data/models/questionnaire/question.dart';

class FrameRecommendationRepository {
  final _dummyData = FrameRecommendationDummyData();

  /// Load and parse the frame recommendation questionnaire from data
  Future<Object> loadQuestionnaire() async {
    // Return cached data if available

    try {
      // Get data from dummy data class
      debugPrint(
        'Loaded frame recommendation data 1: ${json.encode(_dummyData.frameQuestionData)}',
      );
      FrameQuestionnaire jsonData = FrameQuestionnaire.fromJson(
        _dummyData.frameQuestionData,
      );
      // Parse to model
      List<Question?>? frameQuestions = jsonData.questions;

      debugPrint(
        'Loaded frame recommendation data 2: ${json.encode(frameQuestions)}',
      );
      return frameQuestions;
    } catch (e) {
      throw Exception('Failed to load frame recommendation data: $e');
    }
  }

  /// Clear the cached questionnaire (useful for testing or refreshing data)

}
