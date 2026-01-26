import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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

    return {'camera': cameraGranted, 'storage': storageGranted};
  }

  /// Open app settings if permission is permanently denied
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check if location permission is granted
  static Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }

  /// Request location always permission (background location)
  static Future<bool> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  /// Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check if microphone permission is granted
  static Future<bool> hasMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  /// Request audio permission
  static Future<bool> requestAudioPermission() async {
    final status = await Permission.audio.request();
    return status.isGranted;
  }

  /// Check if audio permission is granted
  static Future<bool> hasAudioPermission() async {
    return await Permission.audio.isGranted;
  }

  /// Request both microphone and audio permissions
  static Future<Map<String, bool>> requestMicrophoneAndAudioPermissions() async {
    final microphoneGranted = await requestMicrophonePermission();
    final audioGranted = await requestAudioPermission();

    return {'microphone': microphoneGranted, 'audio': audioGranted};
  }

  /// Request notification permission (mainly for iOS 10+ and Android 13+)
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Check if notification permission is granted
  static Future<bool> hasNotificationPermission() async {
    return await Permission.notification.isGranted;
  }

  /// Request contacts permission
  static Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// Check if contacts permission is granted
  static Future<bool> hasContactsPermission() async {
    return await Permission.contacts.isGranted;
  }

  /// Request bluetooth permission
  static Future<bool> requestBluetoothPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 31) {
        // Android 12+ requires separate Bluetooth permissions
        final scan = await Permission.bluetoothScan.request();
        final connect = await Permission.bluetoothConnect.request();
        return scan.isGranted && connect.isGranted;
      }
    }
    final status = await Permission.bluetooth.request();
    return status.isGranted;
  }

  /// Check if bluetooth permission is granted
  static Future<bool> hasBluetoothPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 31) {
        final scan = await Permission.bluetoothScan.isGranted;
        final connect = await Permission.bluetoothConnect.isGranted;
        return scan && connect;
      }
    }
    return await Permission.bluetooth.isGranted;
  }

  /// Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Check status of a specific permission
  static Future<PermissionStatus> checkPermissionStatus(
    Permission permission,
  ) async {
    return await permission.status;
  }

  /// Check if a permission is permanently denied
  static Future<bool> isPermissionPermanentlyDenied(
    Permission permission,
  ) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// Request permission with detailed status handling
  static Future<Map<String, dynamic>> requestPermissionWithStatus(
    Permission permission,
  ) async {
    final status = await permission.request();

    return {
      'granted': status.isGranted,
      'denied': status.isDenied,
      'permanentlyDenied': status.isPermanentlyDenied,
      'restricted': status.isRestricted,
      'limited': status.isLimited,
    };
  }

  /// Handle permission request with automatic settings navigation for permanently denied
  static Future<bool> handlePermissionRequest(
    Permission permission, {
    Function()? onGranted,
    Function()? onDenied,
    Function()? onPermanentlyDenied,
  }) async {
    final status = await permission.request();

    if (status.isGranted) {
      onGranted?.call();
      return true;
    } else if (status.isPermanentlyDenied) {
      onPermanentlyDenied?.call();
      return false;
    } else {
      onDenied?.call();
      return false;
    }
  }

  /// Get Android SDK version
  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt;
      } catch (e) {
        // Fallback to API 33 if unable to get version
        return 33;
      }
    }
    return 0;
  }
}
