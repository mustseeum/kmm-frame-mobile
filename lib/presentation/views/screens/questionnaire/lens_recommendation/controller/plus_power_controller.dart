import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/data/models/data_response/questionnaire/question.dart';
import 'package:kacamatamoo/data/repositories/question_recommendation/question_recommendation_repository.dart';
import 'package:kacamatamoo/core/network/dio_module.dart';

class PlusPowerController extends BaseController {
  final _repository = QuestionRecommendationRepository(DioModule.getInstance());

  // Options to display (loaded from data)
  final options = <String>[].obs;

  // Question text from data
  final questionText = ''.obs;

  // Loading state
  final isLoading = true.obs;

  // Question data
  List<Question?>? questionData = [];
  Question? ageQuestion;

  String screenType = 'lens_recommendation';

  // Index of selected option (-1 means none)
  final selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _loadQuestionData();
  }

  Future<void> _loadQuestionData() async {
    try {
      isLoading.value = true;

      // Load questionnaire from repository
      final questionnaire = await _repository.loadQuestionnaireLens();
      debugPrint(
        'Loaded lens recommendation data 3: ${json.encode(questionnaire)}',
      );
      if (questionnaire != null) {
        questionData = questionnaire as List<Question?>?;
      }

      ageQuestion = questionData?.firstWhere(
        (q) => q?.id == 'plus_power',
      );

      // Extract option values and question text
      options.value = ageQuestion!.options.map((opt) => opt.value).toList();
      questionText.value = ageQuestion?.question ?? '';
      debugPrint('Loaded lens recommendation data 4: ${json.encode(options)}');

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
      // debugPrint('Selected age option: ${options[idx]}');
      Navigation.navigateToWithArguments(
        ScreenRoutes.astigmatismScreen,
        arguments: {'selectedAge': options[idx], 'screenType': screenType},
      );
    }
  }

  String? get selectedOption =>
      (selectedIndex.value >= 0 ? options[selectedIndex.value] : null);

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
    final type = arguments['screenType'] as String?;
    debugPrint('AgeController received screenType: $type');
    if (type != null) {
      screenType = type;
    }
  }
}
