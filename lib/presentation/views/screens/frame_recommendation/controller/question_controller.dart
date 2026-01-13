import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utils/navigation_helper.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/question.dart';
import 'package:kacamatamoo/data/repositories/question_recommendation_repository.dart';

/// QuestionController with constructor dependency injection (DI).
/// The repository is injected via the binding so the controller is easier to test.
class QuestionController extends BaseController {
  final QuestionRecommendationRepository _repository;

  // Constructor expects a repository instance (injected via Get.lazyPut in binding)
  QuestionController({required QuestionRecommendationRepository repository})
    : _repository = repository;

  // Options to display (loaded from data)
  final options = <String>[].obs;

  // Index in questions list
  final currentIndex = 0.obs;

  // selected option index for current question (-1 none)
  final selectedIndex = (-1).obs;

  // Loading state
  final isLoading = true.obs;

  // Observable for totalSteps and currentStep
  final totalSteps = 0.obs;
  final currentStep = 0.obs;

  // Question data
  List<Question?>? questionData = [];
  Question? ageQuestion;

  String screenType = 'frame';

  @override
  void onInit() {
    super.onInit();
    _loadQuestionData();
  }

  Future<void> _loadQuestionData() async {
    try {
      isLoading.value = true;

      // Load questionnaire from repository. The repository uses your dummy data.
      final questionnaire = await _repository.loadQuestionnaire(
        type: screenType,
      );
      debugPrint('Loaded questionnaire data: ${json.encode(questionnaire)}');
      if (questionnaire != null) {
        questionData = questionnaire.questions;
        totalSteps.value = questionnaire.totalSteps;
      }

      // Find the age question (id: 'age')
      ageQuestion = questionData?.firstWhere(
        (q) => q?.id == 'age',
        orElse: () => null,
      );

      // Set current step from the question data
      if (ageQuestion != null) {
        currentStep.value = ageQuestion!.step;
        options.value = ageQuestion!.options.map((opt) => opt.value).toList();
        debugPrint('Loaded options: ${json.encode(options)}');
      } else {
        options.clear();
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load question data: $e');
    }
  }

  void select(int idx) {
    if (selectedIndex.value == idx) {
      selectedIndex.value = -1; // toggle off when tapped again (optional)
    } else {
      selectedIndex.value = idx;
      // navigate to next screen and pass the chosen age + screenType
      Navigation.navigateToWithArguments(
        ScreenRoutes.wearPurposeScreen,
        arguments: {'selectedAge': options[idx], 'screenType': screenType},
      );
    }
  }

  String? get selectedOption =>
      (selectedIndex.value >= 0 ? options[selectedIndex.value] : null);

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // handle incoming args (example: screenType)
    final type = arguments['screenType'] as String?;
    debugPrint('QuestionController received screenType: $type');
    if (type != null && type.isNotEmpty) {
      screenType = type;
    }
  }
}
