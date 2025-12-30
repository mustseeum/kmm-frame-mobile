import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';
import 'package:permission_handler/permission_handler.dart';

/// Controller for managing AR glasses try-on functionality using GetX.
/// Handles user PD, tracking status, and AR session management.
class GlassesTryOnExampleController extends GetxController {
  // User's PD (could come from profile, prescription, or in-app measurement)
  final Rx<double?> _userPD = Rx<double?>(null);
  double? get userPD => _userPD.value;

  // Tracking status
  final Rx<Map<String, dynamic>?> _trackingStatus = Rx<Map<String, dynamic>?>(
    null,
  );
  Map<String, dynamic>? get trackingStatus => _trackingStatus.value;

  // Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void onReady() {
    super.onReady();
    _initCameraFlow();
  }

  /// Initialize controller and load user data
  Future<void> initialize() async {
    await _loadUserPD();
    await _checkTrackingStatus();
  }

  Future<void> _initCameraFlow() async {
    final granted = await requestCameraPermission();
    if (!granted) {
      //   await startCamera();
      openAppSettings();
    }
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

  /// Load user's PD from preferences/backend
  Future<void> _loadUserPD() async {
    // TODO: Load from your backend or SharedPreferences
    // Example: _userPD.value = await UserPreferences.getPD();

    // For demo purposes, using a sample value
    _userPD.value = 62.5; // Sample PD value
  }

  /// Check device tracking capabilities
  Future<void> _checkTrackingStatus() async {
    try {
      final status = await FaceArChannel.getTrackingStatus();
      _trackingStatus.value = status;
    } catch (e) {
      Get.log('Failed to check tracking status: $e');
    }
  }

  /// Update user's PD
  void setUserPD(double pd) {
    if (pd >= 54 && pd <= 74) {
      _userPD.value = pd;
      // TODO: Save to backend/preferences
      // Example: await UserPreferences.savePD(pd);
    }
  }

  /// Start AR try-on for a specific glasses model
  Future<void> startTryOn(String modelPath) async {
    try {
      _isLoading.value = true;

      // Start AR with user's PD if available
      await FaceArChannel.startFaceAr(modelPath, userPD: _userPD.value);
    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to start try-on: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Example: Try on from backend recommendation
  Future<void> tryRecommendedFrame() async {
    // In real app, this would come from your ML backend
    const recommendedModelUrl =
        'https://your-cdn.com/models/ray_ban_aviator.glb';

    await startTryOn(recommendedModelUrl);
  }

  /// Example: Try on from local assets
  Future<void> tryLocalFrame() async {
    const localModelPath = 'assets/model_3d/test_image_asset.glb';

    await startTryOn(localModelPath);
  }

  /// Validate PD value
  bool isValidPD(double pd) {
    return pd >= 54 && pd <= 74;
  }

  /// Get PD display text
  String getPDDisplayText() {
    return _userPD.value != null
        ? 'PD: ${_userPD.value!.toStringAsFixed(1)}mm'
        : 'PD: Not set';
  }

  /// Get tracking mode display text
  String getTrackingModeText() {
    if (_trackingStatus.value == null) return 'Unknown';
    return _trackingStatus.value!['isARCoreActive'] == true
        ? 'Premium ARCore Tracking'
        : 'Standard ML Kit Tracking';
  }

  /// Check if ARCore is active
  bool get isARCoreActive {
    return _trackingStatus.value?['isARCoreActive'] == true;
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
