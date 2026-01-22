import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/core/utilities/language_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:kacamatamoo/data/json_question/en_question/frame_recommendation.dart';
import 'package:kacamatamoo/data/json_question/en_question/lens_recommendation.dart';
import 'package:kacamatamoo/data/json_question/id_question/frame_recommendation_id.dart';
import 'package:kacamatamoo/data/json_question/id_question/lens_recommendation_id.dart';

class GlobalFunctionHelper {
  GlobalFunctionHelper._();

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

  /// Saves an image file to local storage (app's documents directory).
  ///
  /// [sourceFilePath] - The source file path to copy from.
  /// [fileName] - Optional custom file name (with extension). If not provided,
  ///              generates a timestamped name.
  /// [subDirectory] - Optional subdirectory within documents folder (e.g., 'images', 'scans').
  ///
  /// Returns the saved file path on success, or null on failure.
  static Future<String?> saveImageToLocalStorage(
    String sourceFilePath, {
    String? fileName,
    String? subDirectory,
  }) async {
    try {
      final File sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        debugPrint('Source file does not exist: $sourceFilePath');
        return null;
      }

      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create subdirectory if specified
      String targetDirPath = directory.path;
      if (subDirectory != null && subDirectory.isNotEmpty) {
        targetDirPath = path.join(directory.path, subDirectory);
        final targetDir = Directory(targetDirPath);
        if (!await targetDir.exists()) {
          await targetDir.create(recursive: true);
        }
      }

      // Generate file name if not provided
      final String targetFileName =
          fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final String targetPath = path.join(targetDirPath, targetFileName);

      // Copy file to target location
      await sourceFile.copy(targetPath);

      debugPrint('Image saved to local storage: $targetPath');
      return targetPath;
    } catch (e, st) {
      debugPrint('Error saving image to local storage: $e');
      debugPrint('Stack trace: $st');
      return null;
    }
  }

  /// Saves image bytes to local storage (app's documents directory).
  ///
  /// [bytes] - The image data as Uint8List.
  /// [fileName] - Optional custom file name (with extension). If not provided,
  ///              generates a timestamped name.
  /// [subDirectory] - Optional subdirectory within documents folder (e.g., 'images', 'scans').
  ///
  /// Returns the saved file path on success, or null on failure.
  static Future<String?> saveImageBytesToLocalStorage(
    Uint8List bytes, {
    String? fileName,
    String? subDirectory,
  }) async {
    try {
      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create subdirectory if specified
      String targetDirPath = directory.path;
      if (subDirectory != null && subDirectory.isNotEmpty) {
        targetDirPath = path.join(directory.path, subDirectory);
        final targetDir = Directory(targetDirPath);
        if (!await targetDir.exists()) {
          await targetDir.create(recursive: true);
        }
      }

      // Generate file name if not provided
      final String targetFileName =
          fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final String targetPath = path.join(targetDirPath, targetFileName);

      // Write bytes to file
      final File targetFile = File(targetPath);
      await targetFile.writeAsBytes(bytes);

      debugPrint('Image bytes saved to local storage: $targetPath');
      return targetPath;
    } catch (e, st) {
      debugPrint('Error saving image bytes to local storage: $e');
      debugPrint('Stack trace: $st');
      return null;
    }
  }

  /// Retrieves a saved image file from local storage.
  ///
  /// [fileName] - The name of the file to retrieve.
  /// [subDirectory] - Optional subdirectory within documents folder.
  ///
  /// Returns the File object if exists, null otherwise.
  static Future<File?> getImageFromLocalStorage(
    String fileName, {
    String? subDirectory,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      String targetDirPath = directory.path;
      if (subDirectory != null && subDirectory.isNotEmpty) {
        targetDirPath = path.join(directory.path, subDirectory);
      }

      final String filePath = path.join(targetDirPath, fileName);
      final File file = File(filePath);

      if (await file.exists()) {
        return file;
      } else {
        debugPrint('File not found: $filePath');
        return null;
      }
    } catch (e) {
      debugPrint('Error retrieving image from local storage: $e');
      return null;
    }
  }

  /// Deletes an image file from local storage.
  ///
  /// [fileName] - The name of the file to delete.
  /// [subDirectory] - Optional subdirectory within documents folder.
  ///
  /// Returns true if deleted successfully, false otherwise.
  static Future<bool> deleteImageFromLocalStorage(
    String fileName, {
    String? subDirectory,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      String targetDirPath = directory.path;
      if (subDirectory != null && subDirectory.isNotEmpty) {
        targetDirPath = path.join(directory.path, subDirectory);
      }

      final String filePath = path.join(targetDirPath, fileName);
      final File file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        debugPrint('File deleted: $filePath');
        return true;
      } else {
        debugPrint('File not found for deletion: $filePath');
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting image from local storage: $e');
      return false;
    }
  }

  /// Lists all files in a local storage directory.
  ///
  /// [subDirectory] - Optional subdirectory within documents folder.
  /// [extension] - Optional file extension filter (e.g., '.jpg', '.png').
  ///
  /// Returns list of file paths.
  static Future<List<String>> listImagesInLocalStorage({
    String? subDirectory,
    String? extension,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      String targetDirPath = directory.path;
      if (subDirectory != null && subDirectory.isNotEmpty) {
        targetDirPath = path.join(directory.path, subDirectory);
      }

      final targetDir = Directory(targetDirPath);
      if (!await targetDir.exists()) {
        return [];
      }

      final List<FileSystemEntity> entities = await targetDir.list().toList();
      final List<String> filePaths = [];

      for (var entity in entities) {
        if (entity is File) {
          if (extension == null || entity.path.endsWith(extension)) {
            filePaths.add(entity.path);
          }
        }
      }

      return filePaths;
    } catch (e) {
      debugPrint('Error listing images in local storage: $e');
      return [];
    }
  }

  /// Formats age string by removing "years old" text.
  ///
  /// Converts "25 years old" to "25", "18-24 years old" to "18-24".
  /// Special case: "Over 51 years old" converts to "51+".
  ///
  /// [ageString] - The age string to format (e.g., "25 years old").
  ///
  /// Returns formatted age string.
  static String formatAgeString(String? ageString) {
    if (ageString == null || ageString.isEmpty) {
      return '';
    }

    // Handle special case: "Over 51 years old" -> "51+"
    if (ageString.toLowerCase().contains('over 51')) {
      return '51+';
    }

    // Remove "years old" (case insensitive)
    String formatted = ageString
        .replaceAll(RegExp(r'\s*years\s*old\s*', caseSensitive: false), '')
        .trim();

    return formatted;
  }

  /// Get the appropriate questionnaire data based on language and type.
  ///
  /// Returns the correct data source for Indonesian or English.
  ///
  /// [language] - Language code ('id', 'id_ID', 'en', 'en_US').
  /// [type] - Question type ('frame' or 'lens').
  ///
  /// Returns the questionnaire data map.
  static Map<String, dynamic> getQuestionnaireDataByLanguage({
    required String language,
    required String type,
  }) {
    final isIndonesian = language == 'id' || language == 'id_ID';

    if (type == 'lens') {
      return isIndonesian
          ? LensRecommendationIDDummyData().lensQuestionData
          : LensRecommendationDummyData().lensQuestionData;
    } else {
      // type == 'frame'
      return isIndonesian
          ? FrameRecommendationIDDummyData().frameQuestionData
          : FrameRecommendationDummyData().frameQuestionData;
    }
  }

  static languageStringCode() {
    Language language = LanguageHelper.loadSavedLanguage();
    final String langCode = LanguageHelper.getLanguageCode(
      language,
    ); // default to English
    return langCode;
  }
}
