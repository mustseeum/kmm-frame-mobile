import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/controller/daily_eye_usage_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_card_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_header_widget.dart';

class DailyEyeUsageScreen extends BasePage<DailyEyeUsageController> {
  const DailyEyeUsageScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    // background color similar to screenshot
    final bg = Theme.of(context); // pale teal-ish
    final controller = Get.find<DailyEyeUsageController>();
    return Scaffold(
      backgroundColor: bg.scaffoldBackgroundColor,
      // Top bar with logo on left and "Step 1 of 4" on right
      appBar: QuestionHeader(
        showBack: false,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('step_5_of_7'.tr, style: TextStyle(color: Colors.blue)),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: MediaQuery.of(context).size.height * 0.13,
            ),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    'how_many_hours_per_day_do_you_use_your_eyes_intensively'.tr,
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
        );
      }),
    );
  }
}
