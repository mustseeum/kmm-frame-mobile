import 'package:flutter/material.dart';
import 'package:get/get.dart';
// face_camera import - adapt based on actual API if names differ
import 'package:face_camera/face_camera.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/controllers/scanning_face/scan_face_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/circle_overlay_widget.dart';

class ScanFaceScreen extends StatelessWidget {
  const ScanFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ScanFaceController>();

    return Scaffold(
      backgroundColor: Color(0xFFEFF7F7),
      body: SafeArea(
        child: Column(
          children: [
            // top bar (logo and step)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'KACAMATAMOO',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0B1A2B)),
                  ),
                  Spacer(),
                  Text('Step 1 of 4', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            Divider(color: Colors.tealAccent.shade700, thickness: 2, height: 2),

            SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                'We will measure your face shapes, skin tone, and eye measurements first!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xFF0B1A2B)),
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: Center(
                child: Obx(() {
                  final showCam = ctrl.showCamera.value;
                  return SizedBox(
                    width: 320,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // camera + circular overlay
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // camera preview area (circular)
                            Container(
                              width: 320,
                              height: 320,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: showCam
                                    // Use SmartFaceCamera and pass the FaceCameraController
                                    ? SmartFaceCamera(
                                        controller: ctrl.faceCameraController,
                                        message: 'Center your face in the circle',
                                      )
                                    // placeholder avatar when camera not shown
                                    : _buildAvatarPlaceholder(),
                              ),
                            ),

                            // circular stroked border
                            Positioned.fill(
                              child: CircleOverlayWidget(
                                borderColor: Colors.grey.shade600,
                                borderWidth: 1.2,
                              ),
                            ),

                            // analyzing progress ring (when analyzing)
                            if (ctrl.analyzing.value)
                              Positioned(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      height: 140,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: ctrl.progress.value / 100.0,
                                            strokeWidth: 6,
                                            color: Colors.deepOrangeAccent,
                                            backgroundColor: Colors.orange.shade100,
                                          ),
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 18),

                        Obx(() {
                          if (ctrl.analyzing.value) {
                            return Column(
                              children: [
                                Text(
                                  '${ctrl.progress.value}% - Analyzing your beautiful face!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xFF0B1A2B)),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Please wait...',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Please put your face ',
                                    children: [
                                      TextSpan(
                                        text: 'Straight',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: ' in the circle'),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 18),
                                ElevatedButton(
                                  onPressed: () {
                                    ctrl.startScanning();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0D3B35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                                    minimumSize: Size(double.infinity, 48),
                                  ),
                                  child: Text('Start Scanning', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          }
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.white.withValues(alpha: 0.0),
      child: Center(
        child: Image.asset(
          AssetsConstants.faceIcon,
          width: 220,
          height: 220,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
