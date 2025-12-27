import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kacamatamoo/app/app.dart';
import 'package:kacamatamoo/core/network/bindings/initial_bindings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // // Setelah binding Flutter aktif → baru boleh memanggil InitialBindings()
  InitialBindings().dependencies();
  
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
