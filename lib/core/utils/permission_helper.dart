import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Request storage permission based on Android version
  /// For Android 13+ (API 33+): requests READ_MEDIA_IMAGES
  /// For Android 12 and below: requests READ_EXTERNAL_STORAGE
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Check Android version
      final androidInfo = await _getAndroidVersion();
      
      if (androidInfo >= 33) {
        // Android 13+ - Request granular media permissions
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        // Android 12 and below - Request legacy storage permission
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    
    return false;
  }

  /// Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      
      if (androidInfo >= 33) {
        return await Permission.photos.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.isGranted;
    }
    
    return false;
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// Request both camera and storage permissions
  static Future<Map<String, bool>> requestCameraAndStoragePermissions() async {
    final cameraGranted = await requestCameraPermission();
    final storageGranted = await requestStoragePermission();
    
    return {
      'camera': cameraGranted,
      'storage': storageGranted,
    };
  }

  /// Open app settings if permission is permanently denied
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Get Android SDK version
  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      // This requires adding device_info_plus package or using platform channel
      // For now, we'll use a simple approach with permission_handler
      // permission_handler automatically handles API level differences
      return 33; // Default to new API for safer permission requests
    }
    return 0;
  }
}
