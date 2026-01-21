import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/data/models/scan_result/scan_result_model.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers.dart';

class ScanResultController extends BaseController {
  // Loading indicator if you want to perform async work when opening this screen
  final RxBool isLoading = false.obs;

  // Face profile result (nullable until loaded)
  final Rxn<ScanResultModel> profile = Rxn<ScanResultModel>();

  // Questionnaire answers with image
  final Rxn<Answers> answers = Rxn<Answers>();

  // Progress or success flag
  final RxBool completed = false.obs;

  // Example: set when the user chooses "Try on Myself"
  final RxBool tryingOn = false.obs;

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
    answers.value = null;
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // Receive answers from scan_face_controller
    final receivedAnswers = arguments['answers'] as Answers?;
    final imagePath = arguments['imagePath'] as String?;
    
    if (receivedAnswers != null) {
      answers.value = receivedAnswers;
      debugPrint('ScanResultController received answers:');
      debugPrint('  age_range: ${receivedAnswers.age_range}');
      debugPrint('  gender_identity: ${receivedAnswers.gender_identity}');
      debugPrint('  looking_for: ${receivedAnswers.looking_for}');
      debugPrint('  imagePath: $imagePath');
      
      // You can now use this data to call an API or process further
      // Example: uploadAnswersToServer();
    }
  }
  
  /// Example method to upload answers to server
  Future<void> uploadAnswersToServer() async {
    if (answers.value == null) {
      debugPrint('No answers to upload');
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Convert to FormData for multipart upload
      final formData = await answers.value!.toFormData();
      
      // TODO: Call your API service here
      // Example: await apiService.uploadScanData(formData);
      
      debugPrint('Answers uploaded successfully');
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error uploading answers: $e');
      isLoading.value = false;
    }
  }
}