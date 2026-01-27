import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_embed_unity/flutter_embed_unity.dart';  // COMMENTED OUT - Unity disabled
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_v2_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/vto/camera_preview.dart';
import 'package:kacamatamoo/presentation/views/widgets/vto/glasses_overlay.dart';
import 'package:kacamatamoo/presentation/views/widgets/vto/glasses_selector.dart';

class VirtualTryOnPageV2 extends GetView<VirtualTryOnV2Controller> {
  const VirtualTryOnPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Binding will be applied when route is created; ensure orientation locked
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800, // Adjust this value as needed
            ),
            child: GetBuilder<VirtualTryOnV2Controller>(
              builder: (_) {
                return Column(
                  children: [
                    // COMMENTED OUT - Unity disabled
                    // SizedBox(
                    //   height: 600, // Set a fixed height for Unity widget
                    //   child: EmbedUnity(
                    //     onMessageFromUnity: (String data) {
                    //       // A message has been received from a Unity script
                    //       // controller.handleUnityMessage(data);
                    //       // if (data == "scene_loaded") {
                    //       //   sendToUnity(
                    //       //     "MyGameObject",
                    //       //     "SpawnKacamata",
                    //       //     "kacamata",
                    //       //   );
                    //       // }
                    //     },
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Send message to Unity
                    //       sendToUnity(
                    //         "MyGameObject",
                    //         "SpawnKacamata",
                    //         "kacamata",
                    //       );
                    //     },
                    //     child: const Text("Set rotation speed"),
                    //   ),
                    // ),
                    const Center(
                      child: Text(
                        'Unity functionality is currently disabled',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16),
                    //   child: Text(
                    //     "Flutter logo has been touched ${controller.numberOfTaps} times",
                    //     textAlign: TextAlign.center,
                    //     style: theme.textTheme.titleMedium,
                    //   ),
                    // ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    // "MyGameObject", // Game object name
    //                   "pawnKacamata", // Unity script function name
    //                   "kacamata", // Message
    // return Scaffold(
    //   body: SafeArea(
    //     // Use LayoutBuilder to measure the exact preview area and pass it to the overlay.
    //     // This ensures the camera -> screen coordinate mapping is precise.
    //     child: LayoutBuilder(
    //       builder: (context, constraints) {
    //         final previewSize = Size(
    //           constraints.maxWidth,
    //           constraints.maxHeight,
    //         );

    //         return GetBuilder<VirtualTryOnV2Controller>(
    //           builder: (_) => Stack(
    //             fit: StackFit.expand,
    //             children: [
    //               // Camera preview (do not mirror here if you want world/window behavior).
    //               CameraPreviewWidget(controller: controller),

    //               // Glasses overlay - reacts to face detections and needs exact previewSize.
    //               GlassesOverlay(
    //                 controller: controller,
    //                 previewSize: previewSize,
    //                 debugMode: true,
    //               ),

    //               // Bottom selector aligned bottom center
    //               Align(
    //                 alignment: Alignment.bottomCenter,
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(bottom: 24.0),
    //                   child: GlassesSelector(controller: controller),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
