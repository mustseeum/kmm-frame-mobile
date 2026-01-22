import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/frame_recommendation/controller/wear_purpose_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_card_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_header_widget.dart';

class WearPurposeScreen extends BasePage<WearPurposeController> {
  const WearPurposeScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    // background color similar to screenshot
    const bg = Color(0xFFEFF9F8); // pale teal-ish
    final controller = Get.find<WearPurposeController>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bg,
        body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              QuestionHeader(
                showBack: false,
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    controller.screenType == "lens"
                        ? 'step_2_of_10'.tr
                        : 'step_2_of_5'.tr,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: MediaQuery.of(context).size.height * 0.13,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Center(
                      child: Text(
                        'how_can_we_identify_you'.tr,
                        style: const TextStyle(
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
                          children: List.generate(controller.options.length, (
                            index,
                          ) {
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
            ],
          ),
        );
      }),
      ),
    );
  }
}
