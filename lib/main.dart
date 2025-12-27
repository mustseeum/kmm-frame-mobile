import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kacamatamoo/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iOS: (dark icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    value,
  ) {
    runApp(KacamataMooApp());
  });
}
