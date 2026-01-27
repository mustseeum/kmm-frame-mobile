import 'dart:developer';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kacamatamoo/app/app.dart';
import 'package:kacamatamoo/core/network/bindings/initial_bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kacamatamoo/core/utilities/logger_utility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for persistent data
  await GetStorage.init();

  // Initialize FaceCamera
  await FaceCamera.initialize();

  // Initialize Firebase
  await Firebase.initializeApp();

  /// To load Logger
  try {
    ChuckerFlutter.showOnRelease = await LoggerUtility()
        .getChuckerReleaseStatus();
    ChuckerFlutter.showNotification = await LoggerUtility()
        .getChuckerShowStatus();
  } catch (e) {
    log(e.toString());
  }

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  // Setelah binding Flutter aktif → baru boleh memanggil InitialBindings()
  InitialBindings().dependencies();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iOS: (dark icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
    ),
  );
  // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then(
  //   (value) {
  //     runApp(KacamataMooApp());
  //   },
  // ); // uncomment this if you want to lock orientation to landscape
  runApp(const KacamataMooApp());
}
