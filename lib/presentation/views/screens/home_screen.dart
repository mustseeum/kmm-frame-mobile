import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';
import 'package:kacamatamoo/presentation/controllers/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.find<HomeScreenController>();

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
                await FaceArChannel.startFaceAr('assets/model_3d/test_image_asset.glb');
              },
              child: const Text('Start Face AR'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await FaceArChannel.stopFaceAr();
              },
              child: const Text('Stop Face AR'),
            ),
          ),
        ],
      ),
    );
  }
}
