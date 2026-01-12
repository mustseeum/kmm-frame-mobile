import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';

class VirtualTryOnPageController extends BaseController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initCameraFlow();
  }

  /// Initialize DeepAR controller
  Future<void> initializeDeepAr() async {
    try {
      debugPrint('[VirtualTryOnPageController] Initializing DeepAR...');
      await ensureDeepArInitialized();
      debugPrint('[VirtualTryOnPageController] DeepAR initialized successfully');
    } catch (e) {
      debugPrint('[VirtualTryOnPageController] Error initializing DeepAR: $e');
      rethrow;
    }
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
      debugPrint('[VirtualTryOnPageController] Starting Face AR with GLB asset...');
      // await FaceArChannel.startFaceAr('assets/model_3d/test_image_asset.glb');
      debugPrint('[VirtualTryOnPageController] Face AR started successfully');
    } catch (e) {
      debugPrint('[VirtualTryOnPageController] Error starting Face AR: $e');
      rethrow;
    }
  }

  Future<void> stopFaceAr() async {
    await FaceArChannel.stopFaceAr();
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
