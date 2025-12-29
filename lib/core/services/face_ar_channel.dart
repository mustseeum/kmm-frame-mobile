import 'package:flutter/services.dart';

class FaceArChannel {
  static const MethodChannel _channel =
      MethodChannel('kacamatamoo/face_ar');

  /// Start native Face AR and load GLB asset
  /// Start native Face AR and load GLB asset.
  ///
  /// `glbAssetPath` can be one of:
  /// - A Flutter packaged asset path under `assets/` (e.g. `assets/model_3d/foo.glb`).
  /// - An absolute local file path (e.g. `/data/user/0/.../cache/foo.glb`) or `file://` URI.
  /// - A remote URL (`https://.../foo.glb`). The native side will download it to cache.
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
