import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kacamatamoo/app/app.dart';
import 'package:kacamatamoo/core/network/bindings/initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FaceCamera.initialize(); //Add this

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  // // Setelah binding Flutter aktif → baru boleh memanggil InitialBindings()
  InitialBindings().dependencies();


  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iOS: (dark icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then(
    (value) {
      runApp(KacamataMooApp());
    },
  );
}
