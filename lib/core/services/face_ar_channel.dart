import 'package:flutter/services.dart';

/// Service class for communicating with native AR face tracking.
/// Provides methods to start/stop AR sessions and pass user parameters.
class FaceArChannel {
  static const MethodChannel _channel =
      MethodChannel('kacamatamoo/face_ar');

  /// Start native Face AR and load GLB asset.
  ///
  /// Parameters:
  /// - `glbAssetPath`: Path to the 3D glasses model file.
  ///   - Flutter asset: `assets/model_3d/foo.glb`
  ///   - Local file: `/data/user/0/.../cache/foo.glb`
  ///   - Remote URL: `https://.../foo.glb` (will be downloaded)
  ///
  /// - `userPD`: Optional user's pupillary distance in millimeters (54-74mm range).
  ///   If provided, ensures accurate frame sizing for the user's face.
  ///   Can be obtained from user's prescription or in-app measurement tool.
  ///
  /// Example:
  /// ```dart
  /// await FaceArChannel.startFaceAr(
  ///   'assets/model_3d/ray_ban_aviator.glb',
  ///   userPD: 62.5, // User's actual PD from prescription
  /// );
  /// ```
  static Future<void> startFaceAr(
    String glbAssetPath, {
    double? userPD,
  }) async {
    final Map<String, dynamic> args = {
      'assetPath': glbAssetPath,
    };

    // Add PD if provided (validate range: 54-74mm for adults)
    if (userPD != null) {
      if (userPD >= 54 && userPD <= 74) {
        args['userPD'] = userPD;
      } else {
        throw ArgumentError(
          'Invalid PD value: $userPD. Must be between 54-74mm for adults.',
        );
      }
    }

    await _channel.invokeMethod('startFaceAr', args);
  }

  /// Stop native Face AR session and release resources.
  /// Call this when user exits try-on mode or closes the app.
  static Future<void> stopFaceAr() async {
    await _channel.invokeMethod('stopFaceAr');
  }

  /// Get current tracking status and capabilities.
  /// Returns information about:
  /// - Whether ARCore Augmented Faces is active (premium mode)
  /// - Current tracking quality
  /// - Measured PD if available
  ///
  /// Returns a Map with keys:
  /// - `isARCoreActive` (bool): True if using ARCore, false if ML Kit
  /// - `trackingQuality` (String): 'excellent', 'good', 'poor', or 'none'
  /// - `measuredPD` (double?): Estimated PD in millimeters
  ///
  /// Example:
  /// ```dart
  /// final status = await FaceArChannel.getTrackingStatus();
  /// if (status['isARCoreActive']) {
  ///   print('Using premium ARCore tracking');
  /// }
  /// ```
  static Future<Map<String, dynamic>> getTrackingStatus() async {
    try {
      final result = await _channel.invokeMethod('getTrackingStatus');
      return Map<String, dynamic>.from(result as Map);
    } catch (e) {
      return {
        'isARCoreActive': false,
        'trackingQuality': 'unknown',
        'measuredPD': null,
      };
    }
  }

  /// Calibrate PD measurement.
  /// User holds device at specified distance and looks straight ahead.
  /// Returns the measured PD in millimeters.
  ///
  /// This can be used to create an in-app PD measurement tool for users
  /// who don't have their prescription handy.
  ///
  /// Parameters:
  /// - `distanceFromCamera`: Distance from camera in millimeters (default: 300mm/30cm)
  ///
  /// Returns: Measured PD in millimeters
  static Future<double?> calibratePD({int distanceFromCamera = 300}) async {
    try {
      final result = await _channel.invokeMethod('calibratePD', {
        'distance': distanceFromCamera,
      });
      return result as double?;
    } catch (e) {
      return null;
    }
  }
}
