import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/data/models/scan_result/scan_result_model.dart';

class ScanResultController extends GetxController {
  // Loading indicator if you want to perform async work when opening this screen
  final RxBool isLoading = false.obs;

  // Face profile result (nullable until loaded)
  final Rxn<ScanResultModel> profile = Rxn<ScanResultModel>();

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
    if (profile.value == null) return;
    tryingOn.value = true;
    // TODO: call your try-on flow (AR / 3D preview / navigation)
    await Future.delayed(const Duration(milliseconds: 600));
    tryingOn.value = false;
    // Example: navigate to try-on screen
    Get.toNamed('/try_on', arguments: profile.value);
  }

  /// Optional: reset profile if user retakes or restarts
  void reset() {
    profile.value = null;
    completed.value = false;
  }
}