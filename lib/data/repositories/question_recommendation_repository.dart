import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kacamatamoo/data/json_question/frame_recommendation.dart';
import 'package:kacamatamoo/data/json_question/lens_recommendation.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/frame_questionnaire.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/question.dart';

class QuestionRecommendationRepository {
  /// Load and parse the frame recommendation questionnaire from data
  /// Load questionnaire questions.
  /// [type] can be 'frame' or 'lens' (defaults to 'frame').
  Future<FrameQuestionnaire?> loadQuestionnaire({String type = 'frame'}) async {
    // Simulate async load (you can remove the delay if loading is instant)
    await Future.delayed(const Duration(milliseconds: 120));

    final raw = type == 'lens'
        ? LensRecommendationDummyData().lensQuestionData
        : FrameRecommendationDummyData().frameQuestionData;

    if (raw == null) return null;

    try {
      return FrameQuestionnaire.fromJson(raw);
    } catch (e) {
      // Forward error so controller can show snackbar / fallback
      return Future.error('Failed to parse questionnaire: $e');
    }
  }

  Future<FrameQuestionnaire?> loadQuestionnaireLens() async {
    final _dummyData = LensRecommendationDummyData();
    // Return cached data if available

    try {
      // Get data from dummy data class
      debugPrint(
        'Loaded lens recommendation data 1: ${json.encode(_dummyData.lensQuestionData)}',
      );
      FrameQuestionnaire jsonData = FrameQuestionnaire.fromJson(
        _dummyData.lensQuestionData,
      );
      
      debugPrint(
        'Loaded lens recommendation data 2: ${json.encode(jsonData)}',
      );
      return jsonData;
    } catch (e) {
      throw Exception('Failed to load lens recommendation data: $e');
    }
  }

  /// Clear the cached questionnaire (useful for testing or refreshing data)
}
