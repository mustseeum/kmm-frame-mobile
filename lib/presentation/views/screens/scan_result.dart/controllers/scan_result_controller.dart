import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/measurements_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_result_data.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_result_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/recommended_frames_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/scan_result_model.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers_data_request.dart';

class ScanResultController extends BaseController {
  // Loading indicator if you want to perform async work when opening this screen
  final RxBool isLoading = false.obs;

  // Face profile result (nullable until loaded)
  final Rxn<ScanResultModel> profile = Rxn<ScanResultModel>();

  // Questionnaire answers with image
  final Rxn<AnswersDataRequest> answersData = Rxn<AnswersDataRequest>();

  // Progress or success flag
  final RxBool completed = false.obs;

  // Example: set when the user chooses "Try on Myself"
  final RxBool tryingOn = false.obs;

  Rx<MLResultDM> mlResultDm = MLResultDM().obs;

  Rx<MlResultData> mlResultData = MlResultData().obs;

  @override
  void onInit() {
    super.onInit();
    // Optionally auto-load a sample or passed-in result
    // loadFromAnalysis(...) can be called from previous screen with real results.
  }

  /// Load results (call this after analysis completes)
  /// Accepts a map or a FaceProfile instance — adapt to your analysis output.
  void loadFromAnalysis(ScanResultModel result) {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 250), () {
      profile.value = result;
      completed.value = true;
      isLoading.value = false;
    });
  }

  /// Handler for retake scan button
  void retakeScan() {
    // stop any resources, navigate back to camera screen
    // Example: Get.back() or Get.offNamed('/scan')
    Get.back(result: {'retake': true});
  }

  /// Handler for Try on Myself button
  Future<void> tryOnMyself() async {
    // if (profile.value == null) return;
    // tryingOn.value = true;
    // // TODO: call your try-on flow (AR / 3D preview / navigation)
    // await Future.delayed(const Duration(milliseconds: 600));
    // tryingOn.value = false;
    // // Example: navigate to try-on screen
    Get.toNamed(ScreenRoutes.tryOnGlasses, arguments: profile.value);
  }

  /// Optional: reset profile if user retakes or restarts
  void reset() {
    profile.value = null;
    completed.value = false;
    answersData.value = null;
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // Receive answers data from scan_face_controller
    debugPrint('ScanResultController received answers data: ${jsonEncode(arguments)}');
    final receivedAnswersData = arguments['answersData'] as AnswersDataRequest?;
    final receivedMlResult = arguments['answerResult'] ?? MLResultDM;
    String imagePath = arguments['imagePath'] ?? "";
    
    if (receivedMlResult != null) {
      mlResultDm.value = receivedMlResult;
    }

    if (receivedAnswersData != null) {
      answersData.value = receivedAnswersData;
      debugPrint('  age_range: ${receivedAnswersData.answers?.age_range}');
      debugPrint(
        '  gender_identity: ${receivedAnswersData.answers?.gender_identity}',
      );
      debugPrint('  looking_for: ${receivedAnswersData.answers?.looking_for}');
      debugPrint('  session_id: ${receivedAnswersData.answers?.session_id}');
      debugPrint('  image: ${receivedAnswersData.image?.path}');

      // You can now use this data to call an API or process further
      // Example: uploadAnswersToServer();
    }

    if (mlResultDm.value != null) {
      debugPrint('  ML Result Data: ${jsonEncode(mlResultDm.value)}');
      // You can now use this data as needed
      mlResultData.value = mlResultDm.value.data ?? MlResultData();
      debugPrint('  ML Result Data: ${jsonEncode(mlResultData.value)}');
      profile.value = ScanResultModel(
        confidenceLevel: mlResultData.value.confidence_level ?? 0.0,
        faceShape: mlResultData.value.face_shape ?? '',
        imageId: mlResultData.value.image_id ?? '',
        measurements: mlResultData.value.measurements ?? MeasurementsDm(),
        recommendedFrames:
            mlResultData.value.recommended_frames ?? RecommendedFramesDm(),
        sessionId: mlResultData.value.session_id ?? '',
        skinTone: mlResultData.value.skin_tone ?? '',
        imagePath: imagePath,
      );
    }
  }

  /// Example method to upload answers to server
  Future<void> uploadAnswersToServer() async {
    if (answersData.value == null) {
      debugPrint('No answers data to upload');
      return;
    }

    try {
      isLoading.value = true;

      // Convert to FormData for multipart upload
      final formData = await answersData.value!.toFormData();

      // TODO: Call your API service here
      // Example: await apiService.uploadScanData(formData);

      debugPrint('Answers data uploaded successfully');
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error uploading answers data: $e');
      isLoading.value = false;
    }
  }

  /// Format measurement value to millimeter string
  String formatMm(int? value) =>
      value == null ? 'X mm' : '$value mm';

  /// Get the top recommended frame type name
  String getTopFrameType() {
    final types = profile.value?.recommendedFrames.types;
    if (types == null || types.isEmpty) return '-';
    
    // Sort by score descending and get the first one
    final sortedTypes = List.from(types)..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return sortedTypes.first.frame_type_name ?? '-';
  }

  /// Get the top recommended frame color name
  String getTopFrameColor() {
    final colors = profile.value?.recommendedFrames.colors;
    if (colors == null || colors.isEmpty) return '-';
    
    // Sort by score descending and get the first one
    final sortedColors = List.from(colors)..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return sortedColors.first.frame_color_name ?? '-';
  }

  /// Get sorted list of frame types by score
  List<Map<String, dynamic>> getFrameTypesList() {
    final types = profile.value?.recommendedFrames.types;
    if (types == null || types.isEmpty) return [];
    
    final sortedTypes = List.from(types)..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return sortedTypes.map((type) => {
      'name': type.frame_type_name ?? '-',
      'score': type.score ?? 0,
    }).toList();
  }

  /// Get sorted list of frame colors by score
  List<Map<String, dynamic>> getFrameColorsList() {
    final colors = profile.value?.recommendedFrames.colors;
    if (colors == null || colors.isEmpty) return [];
    
    final sortedColors = List.from(colors)..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return sortedColors.map((color) => {
      'name': color.frame_color_name ?? '-',
      'score': color.score ?? 0,
    }).toList();
  }
}
