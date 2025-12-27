import 'package:flutter/services.dart';

class FaceArChannel {
  static const MethodChannel _channel =
      MethodChannel('kacamatamoo/face_ar');

  /// Start native Face AR and load GLB asset
  static Future<void> startFaceAr(String glbAssetPath) async {
    await _channel.invokeMethod('startFaceAr', {
      'assetPath': glbAssetPath,
    });
  }

  /// Stop native Face AR
  static Future<void> stopFaceAr() async {
    await _channel.invokeMethod('stopFaceAr');
  }
}
