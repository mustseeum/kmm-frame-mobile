import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/data/models/questionnaire/question.dart';
import 'package:kacamatamoo/data/repositories/frame_recommendation_repository.dart';

class AgeController extends GetxController {
  final _repository = FrameRecommendationRepository();

  // Options to display (loaded from data)
  final options = <String>[].obs;

  // Loading state
  final isLoading = true.obs;

  // Question data
  List<Question?>? questionData = [];
  Question? ageQuestion;

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
      final questionnaire = await _repository.loadQuestionnaire();
      debugPrint(
        'Loaded frame recommendation data 3: ${json.encode(questionnaire)}',
      );
      if (questionnaire != null) {
        questionData = questionnaire as List<Question?>?;
      }
      // Find the age question (id: 'age', step: 1)
      ageQuestion = questionData?.firstWhere((q) => q?.id == 'age');

      // Extract option values
      options.value = ageQuestion!.options.map((opt) => opt.value).toList();
      debugPrint(
        'Loaded frame recommendation data 4: ${json.encode(options)}',
      );

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
      Get.toNamed(ScreenRoutes.wearPurposeScreen);
    }
  }

  String? get selectedOption =>
      (selectedIndex.value >= 0 ? options[selectedIndex.value] : null);
}
