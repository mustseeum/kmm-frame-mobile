import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utils/navigation_helper.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/question.dart';
import 'package:kacamatamoo/data/repositories/question_recommendation_repository.dart';

class WearPurposeController extends BaseController {
  final _repository = QuestionRecommendationRepository();

  // Options to display (loaded from data)
  final options = <String>[].obs;

  // Loading state
  final isLoading = true.obs;

  // Observable for totalSteps and currentStep
  final totalSteps = 0.obs;
  final currentStep = 0.obs;

  // Question data
  List<Question?>? questionData = [];
  Question? ageQuestion;

  // Index of selected option (-1 means none)
  final selectedIndex = (-1).obs;

  String screenType = 'frame';

  @override
  void onInit() {
    super.onInit();
    _loadQuestionData();
  }

  Future<void> _loadQuestionData() async {
    try {
      isLoading.value = true;

      // Load questionnaire from repository
      final questionnaire = await _repository.loadQuestionnaire();

      if (questionnaire != null) {
        questionData = questionnaire.questions;
        totalSteps.value = questionnaire.totalSteps;
      }

      ageQuestion = questionData?.firstWhere((q) => q?.id == 'gender');

      // Set current step from the question data
      if (ageQuestion != null) {
        currentStep.value = ageQuestion!.step;
        // Extract option values
        options.value = ageQuestion!.options.map((opt) => opt.value).toList();
        debugPrint('Loaded frame recommendation data 4: ${json.encode(options)}');
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
      debugPrint('Selected age option: ${options[idx]}');
      if (screenType == 'frame') {
        Navigation.navigateToWithArguments(
          ScreenRoutes.scanningFaceScreen,
          arguments: {'selectedGender': options[idx], 'screenType': screenType},
        );
      } else if (screenType == 'lens') {
        Navigation.navigateToWithArguments(
          ScreenRoutes.lensPrescriptionScreen,
          arguments: {'selectedGender': options[idx], 'screenType': screenType},
        );
      } else if (screenType == 'both') {
        Navigation.navigateToWithArguments(
          ScreenRoutes.scanningFaceScreen,
          arguments: {'selectedGender': options[idx], 'screenType': screenType},
        );
      }
    }
  }

  String? get selectedOption =>
      (selectedIndex.value >= 0 ? options[selectedIndex.value] : null);

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
    final type = arguments['screenType'] as String?;
    debugPrint('WearPurposeController received screenType: $type');
    if (type != null) {
      screenType = type;
    }
  }
}
