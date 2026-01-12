import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/privacy_intro_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/global_header_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/privacy_intro_widget.dart';

class PrivacyIntroScreen extends BasePage<PrivacyIntroController> {
  const PrivacyIntroScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final ctrl = Get.find<PrivacyIntroController>();
    final baseColor = const Color(0xFFEFF9F8); // pale mint background
    return Scaffold(
      backgroundColor: baseColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: const GlobalHeader(),
      ),
      body: Obx(() => PrivacyIntroWidget(
        onAgree: () => ctrl.agreeAndContinue(),
        onPrivacyPolicyTap: () => ctrl.openPrivacyPolicy(),
        isLoading: ctrl.isLoading.value,
        isButtonEnabled: ctrl.hasAgreedToPrivacy.value,
      )),
    );
  }
}
