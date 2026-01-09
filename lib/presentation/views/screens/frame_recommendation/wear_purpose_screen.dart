import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/frame_recommendation/wear_purpose_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_card_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_header_widget.dart';

class WearPurposeScreen extends GetView<WearPurposeController> {
  const WearPurposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // background color similar to screenshot
    const bg = Color(0xFFEFF9F8); // pale teal-ish

    return Scaffold(
      backgroundColor: bg,
      // Top bar with logo on left and "Step 1 of 4" on right
      appBar: QuestionHeader(
        showBack: false,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('Step 2 of 5', style: TextStyle(color: Colors.blue)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: MediaQuery.of(context).size.height * 0.13),
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Center(
                child: Text(
                  'What are you looking for?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0E2546),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // Grid of cards (2 columns)
              LayoutBuilder(
                builder: (context, constraints) {
                  // width available, we use two columns with spacing
                  final double spacing = 20;
                  final double totalSpacing = spacing;
                  final double cardWidth =
                      (constraints.maxWidth - totalSpacing) / 2;

                  return Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    alignment: WrapAlignment.center,
                    children: List.generate(controller.options.length, (index) {
                      return SizedBox(
                        width: cardWidth,
                        child: Obx(() {
                          final isSelected =
                              controller.selectedIndex.value == index;
                          return QuestionCardWidget(
                            text: controller.options[index],
                            selected: isSelected,
                            onTap: () => controller.select(index),
                          );
                        }),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
