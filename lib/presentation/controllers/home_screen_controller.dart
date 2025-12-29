import 'package:get/get.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';

class HomeScreenController extends GetxController {
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
    // TODO: initialize camera controller / navigate to camera view
    await FaceArChannel.startFaceAr('assets/model_3d/test_triangel.obj');
  }

  Future<void> stopFaceAr() async {
    await FaceArChannel.stopFaceAr();
  }
}
