import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/try_on_glasses_controller.dart';

class TryOnGlassesScreen extends StatelessWidget {
  TryOnGlassesScreen({super.key});
  final controller = Get.find<TryOnGlassesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await controller.startCamera();
              },
              child: const Text('Start Face AR'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await controller.stopFaceAr();
              },
              child: const Text('Stop Face AR'),
            ),
          ),
        ],
      ),
    );
  }
}
