import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/frame_recommendation/controller/question_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_card_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_header_widget.dart';

class QuestionScreen extends BasePage<QuestionController> {
  const QuestionScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    // background color similar to screenshot
    const bg = Color(0xFFEFF9F8); // pale teal-ish
    final controller = Get.find<QuestionController>();

    return Scaffold(
      backgroundColor: bg,

      // Wrap AppBar in PreferredSize to ensure it implements PreferredSizeWidget
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: QuestionHeader(
          trailing: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              controller.screenType == "lens"
                  ? 'step_1_of_10'.tr
                  : 'step_1_of_5'.tr,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
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

                // Title from data (ageQuestion.question) if available; fallback to localized text
                // final q = controller.ageQuestion;
                //   final title = (q != null && q.question.isNotEmpty) ? q.question : 'how_old_are_you'.tr;
                Center(
                  child: Text(
                    controller.ageQuestion?.question.isNotEmpty ?? false
                        ? controller.ageQuestion!.question
                        : 'how_old_are_you'.tr,
                    textAlign: TextAlign.center,
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
                    const double spacing = 20;
                    final double cardWidth =
                        (constraints.maxWidth - spacing) / 2;

                    return Wrap(
                      runSpacing: 20,
                      spacing: spacing,
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
