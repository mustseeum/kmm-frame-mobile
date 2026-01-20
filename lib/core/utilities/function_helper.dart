import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';


class FunctionHelper {
  FunctionHelper._();

  /// Determines if the current screen width is tablet size.
  ///
  /// Returns `true` if the max width is greater than or equal to 768.
  static bool isTablet(BoxConstraints constraints) {
    return constraints.maxWidth >= 768;
  }

  /// Calculates the container width based on screen size.
  ///
  /// Returns 60% of the screen width for tablets, and 92% for mobile devices.
  static double getContainerWidth(BoxConstraints constraints) {
    final isTabletSize = isTablet(constraints);
    return isTabletSize
        ? constraints.maxWidth * 0.6
        : constraints.maxWidth * 0.92;
  }

  /// Requests and handles camera permission.
  ///
  /// Returns `true` when permission is granted. If permission is permanently
  /// denied and [openSettingsIfPermanentlyDenied] is `true`, the app settings
  /// screen will be opened.
  static Future<bool> handleCameraPermission({
    bool openSettingsIfPermanentlyDenied = false,
  }) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      if (openSettingsIfPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }

    // Fallback: request permission
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  static String aesEncrypt(String value, String secret) {
    final key = prepareSecretKey(secret);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.ecb),
    );

    final encrypted = encrypter.encrypt(value);

    return encrypted.base64;
  }

  static String aesDecrypt(String value, String secret) {
    final key = prepareSecretKey(secret);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.ecb),
    );

    final encryptedData = encrypt.Encrypted.fromBase64(value);

    final decrypted = encrypter.decrypt(encryptedData);

    return decrypted;
  }

  static encrypt.Key prepareSecretKey(String secret) {
    List<int> keyBytes = utf8.encode(secret);
    Digest sha1Digest = sha1.convert(keyBytes);
    List<int> paddedKey = List<int>.filled(16, 0);
    List<int> sha1Bytes = sha1Digest.bytes;
    int minLength = sha1Bytes.length > paddedKey.length
        ? paddedKey.length
        : sha1Bytes.length;
    for (int i = 0; i < minLength; i++) {
      paddedKey[i] = sha1Bytes[i];
    }
    return encrypt.Key(Uint8List.fromList(paddedKey));
  }
}
