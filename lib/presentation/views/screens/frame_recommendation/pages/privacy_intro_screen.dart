import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/privacy_intro_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/global_header_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/privacy_intro_widget.dart';

class PrivacyIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PrivacyIntroController>();
    final baseColor = const Color(0xFFEFF9F8); // pale mint background
    return Scaffold(
      backgroundColor: baseColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: const GlobalHeader(),
      ),
      body: PrivacyIntroWidget(
        onAgree: () => ctrl.agreeAndContinue(),
        onPrivacyPolicyTap: () => ctrl.openPrivacyPolicy(),
        isLoading: ctrl.isLoading.value,
        buttonColor: Colors.blue, // optional customization
      ),
    );
  }
}
