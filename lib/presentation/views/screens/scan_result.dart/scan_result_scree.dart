import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/scan_result/scan_result_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/profile_card.dart';
import 'package:kacamatamoo/presentation/views/widgets/info_tile.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_header_widget.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScanResultController>();
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8F7),
      appBar: QuestionHeader(
        showBack: false,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('Step 4 of 5', style: TextStyle(color: Colors.blue)),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = controller.profile.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
            child: Column(
              children: [
                Container(height: 2, color: const Color(0xFF2AA6A6)),
                const SizedBox(height: 18),

                const Text(
                  'Analyze completed!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF06293D)),
                ),
                const SizedBox(height: 18),

                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;

                    final leftWidth = width * 0.55;
                    final rightWidth = width - leftWidth - 24;

                    final avatarDiameter = (leftWidth * 0.95).clamp(220.0, height * 0.95);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT: large image area
                        SizedBox(
                          width: leftWidth,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: Container(
                                width: avatarDiameter,
                                height: avatarDiameter,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(200),
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ClipOval(
                                    child: profile?.imagePath != null
                                        ? _buildImage(profile!.imagePath)
                                        : Image.asset(AssetsConstants.faceIcon, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 24),

                        // RIGHT: information cards (read-only)
                        SizedBox(
                          width: rightWidth,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Face Profile
                                ProfileCard(
                                  title: 'Face Profile',
                                  icon: Icons.account_circle,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InfoTile(
                                            label: 'Face Shape',
                                            value: profile?.faceShape ?? '-',
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: InfoTile(
                                            label: 'Skin tone',
                                            value: profile?.skinTone ?? '-',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Measurement
                                ProfileCard(
                                  title: 'Measurement',
                                  icon: Icons.straighten,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: InfoTile(label: 'Face Width', value: _mm(profile?.faceWidth))),
                                        const SizedBox(width: 12),
                                        Expanded(child: InfoTile(label: 'Eye Length', value: _mm(profile?.eyeLength))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: InfoTile(label: 'Eye Width', value: _mm(profile?.eyeWidth))),
                                        const SizedBox(width: 12),
                                        Expanded(child: InfoTile(label: 'Eye Height', value: _mm(profile?.eyeHeight))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: InfoTile(label: 'Bridge', value: _mm(profile?.bridge))),
                                        const SizedBox(width: 12),
                                        Expanded(child: InfoTile(label: 'Temple Length', value: _mm(profile?.templeLength))),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Perfect Match
                                ProfileCard(
                                  title: 'Perfect Match',
                                  icon: Icons.style,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: InfoTile(label: 'Frame', value: profile?.suggestedFrame ?? '-')),
                                        const SizedBox(width: 12),
                                        Expanded(child: InfoTile(label: 'Color', value: profile?.suggestedColor ?? '-')),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 28),

                                // Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: controller.retakeScan,
                                        icon: const Icon(Icons.arrow_back),
                                        label: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 12.0),
                                          child: Text('Retake Scan', style: TextStyle(fontWeight: FontWeight.w600)),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(color: Colors.black12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: controller.tryOnMyself,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0B413F),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        child: Obx(() {
                                          if (controller.tryingOn.value) {
                                            return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                                          }
                                          return const Text('Try on Myself', style: TextStyle(fontWeight: FontWeight.bold));
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    if (File(path).existsSync()) {
      return Image.file(File(path), fit: BoxFit.cover);
    }
    return Image.asset(path, fit: BoxFit.cover);
  }

  String _mm(double? value) => value == null ? 'X mm' : '${value.toStringAsFixed(0)} mm';
}