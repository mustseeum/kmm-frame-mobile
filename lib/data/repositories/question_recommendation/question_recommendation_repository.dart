import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kacamatamoo/core/base/http_connection/base_repo.dart';
import 'package:kacamatamoo/core/utilities/global_function_helper.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/frame_questionnaire.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/question.dart';

class QuestionRecommendationRepository extends BaseRepo {
  QuestionRecommendationRepository(super.dio);

  /// Load and parse the frame recommendation questionnaire from data
  /// Load questionnaire questions.
  /// [type] can be 'frame' or 'lens' (defaults to 'frame').
  /// [language] can be 'id', 'id_ID', 'en', or 'en_US' (defaults to 'en').

  Future<List<Question?>?> loadQuestionnaire({
    String type = 'frame',
    String language = 'en',
  }) async {
    // Simulate async load (you can remove the delay if loading is instant)
    await Future.delayed(const Duration(milliseconds: 120));

    final raw = GlobalFunctionHelper.getQuestionnaireDataByLanguage(
      language: language,
      type: type,
    );

    final qList = raw['questions'];
    if (qList == null || qList is! List) return null;

    try {
      final out = <Question?>[];
      for (final dynamic q in qList) {
        if (q is Map<String, dynamic>) {
          // Use your model factory; adjust if it's named differently.
          out.add(Question.fromJson(q));
        } else if (q is Map) {
          out.add(Question.fromJson(Map<String, dynamic>.from(q)));
        } else {
          out.add(null);
        }
      }
      return out;
    } catch (e) {
      // Forward error so controller can show snackbar / fallback
      return Future.error('Failed to parse questionnaire: $e');
    }
  }

  Future<Object> loadQuestionnaireLens({String language = 'en'}) async {
    // Return cached data if available

    try {
      // Get data from dummy data class based on language
      final questionData = GlobalFunctionHelper.getQuestionnaireDataByLanguage(
        language: language,
        type: 'lens',
      );
      
      debugPrint(
        'Loaded lens recommendation data 1: ${json.encode(questionData)}',
      );
      FrameQuestionnaire jsonData = FrameQuestionnaire.fromJson(
        questionData,
      );
      // Parse to model
      List<Question?>? lensQuestions = jsonData.questions;

      debugPrint(
        'Loaded lens recommendation data 2: ${json.encode(lensQuestions)}',
      );
      return lensQuestions;
    } catch (e) {
      throw Exception('Failed to load lens recommendation data: $e');
    }
  }
}
