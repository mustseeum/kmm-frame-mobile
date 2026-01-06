import 'package:ar_flutter_plugin_engine/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/controllers/try_on_glasses_controller.dart';
import 'package:ar_flutter_plugin_engine/ar_flutter_plugin.dart';

class TryOnGlassesScreen extends StatelessWidget {
  TryOnGlassesScreen({super.key});
  final ctrl = Get.find<TryOnGlassesController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TryOnGlassesController());

    return Scaffold(
      appBar: AppBar(title: const Text('Face AR Filter')),
      body: Stack(
        children: [
          // AR View
          ARView(
            onARViewCreated: (ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
              // ar_flutter_plugin provides callbacks with managers; adjust to exact API of your plugin version.
              controller.onARViewCreated(arSessionManager, arObjectManager);
            },
            planeDetectionConfig: PlaneDetectionConfig.none, // we only need face anchors
          ),

          // UI overlay
          Positioned(
            left: 12,
            right: 12,
            bottom: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => controller.isLoading.value
                    ? const Card(
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Loading model…', style: TextStyle(color: Colors.white)),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Example local asset path: ensure you put model in assets/models/mask.glb and declare in pubspec
                          await controller.addLocalGLB(AssetsConstants.modelGlasses, scale: [0.025, 0.025, 0.025]);
                        },
                        child: const Text('Use local GLB'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Example remote URL - replace with your REST API response URL
                          const remoteUrl = 'https://example.com/assets/face_filter.glb';
                          await controller.addRemoteGLB(remoteUrl, scale: [0.025, 0.025, 0.025]);
                        },
                        child: const Text('Load remote GLB'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}