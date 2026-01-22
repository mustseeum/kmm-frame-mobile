import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/privacy_policies/controller/privacy_intro_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_header_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/other/privacy_intro_widget.dart';

class PrivacyIntroScreen extends BasePage<PrivacyIntroController> {
  const PrivacyIntroScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final ctrl = Get.find<PrivacyIntroController>();
    final baseColor = const Color(0xFFEFF9F8); // pale mint background
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: baseColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30 + kToolbarHeight),
          child: const QuestionHeader(
            fontSize: 15,
            stepText: 'AI–Powered Virtual Try On System',
            fontWeight: FontWeight.w500,
          ),
        ),
        body: Obx(
          () => PrivacyIntroWidget(
            cardColor: AppColors.a400,
            onAgree: () => ctrl.agreeAndContinue(),
            onPrivacyPolicyTap: () => ctrl.openPrivacyPolicy(),
            isLoading: ctrl.isLoading.value,
            isButtonEnabled: ctrl.hasAgreedToPrivacy.value,
          ),
        ),
      ),
    );
  }
}
