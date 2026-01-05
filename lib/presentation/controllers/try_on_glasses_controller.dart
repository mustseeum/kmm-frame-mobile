import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';

class TryOnGlassesController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initCameraFlow();
  }

  Future<void> _initCameraFlow() async {
    final granted = await requestCameraPermission();
    // if (granted) {
    //   await startCamera();
    // }
  }

  /// Requests camera permission using the global helper.
  /// Returns `true` when permission is granted.
  Future<bool> requestCameraPermission({
    bool openSettingsIfPermanentlyDenied = false,
  }) async {
    return await FunctionHelper.handleCameraPermission(
      openSettingsIfPermanentlyDenied: openSettingsIfPermanentlyDenied,
    );
  }

  /// Start camera-related work. Implement camera initialization here.
  Future<void> startCamera() async {
    try {
      debugPrint('[TryOnGlassesController] Starting Face AR with GLB asset...');
      // await FaceArChannel.startFaceAr('assets/model_3d/test_image_asset.glb');
      Get.offNamed(ScreenRoutes.exampleTryOnGlasses);
      debugPrint('[TryOnGlassesController] Face AR started successfully');
    } catch (e) {
      debugPrint('[TryOnGlassesController] Error starting Face AR: $e');
      rethrow;
    }
  }

  Future<void> stopFaceAr() async {
    await FaceArChannel.stopFaceAr();
  }
}
