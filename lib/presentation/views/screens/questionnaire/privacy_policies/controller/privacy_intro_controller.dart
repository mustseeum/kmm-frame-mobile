import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/data/business_logic/privacy_policies_bl.dart';
import 'package:kacamatamoo/presentation/views/widgets/other/privacy_policy_dialog.dart';

class PrivacyIntroController extends BaseController {
  // Loading state for the Agree button (e.g., show spinner or disable)
  final isLoading = false.obs;

  // Track if user has read and agreed to privacy policy
  final hasAgreedToPrivacy = false.obs;

  // URL for the privacy policy; replace with your real link
  final String privacyUrl = 'https://example.com/privacy';
  final PrivacyPoliciesBl _privacyPoliciesBl = PrivacyPoliciesBl();
  
  // Big sample text: paragraphs separated by blank lines.
  final _sampleText = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lacus ipsum, tempus et condimentum quis, laoreet non nisl. Donec luctus turpis consequat, pulvinar lorem ut, sagittis diam. Nulla nibh nulla, condimentum et nunc id, ornare mattis elit. Maecenas facilisis sagittis arcu, eu tristique augue. Nulla ut metus in enim aliquet auctor eget non ex. Quisque at porttitor nunc.

Nam accumsan massa nec libero auctor, eu pulvinar leo sodales. Pellentesque sodales quam felis, sed fringilla purus vulputate eu. Mauris consectetur neque eget egestas aliquet. Mauris consequat sollicitudin suscipit. Ut in ornare mi, lobortis mollis leo. Nulla porta urna ut lacus placerat, vitae tempus odio sagittis. Proin tempus augue sem, a efficitur lectus vehicula hendrerit.

Praesent a felis non risus congue pulvinar. Integer finibus, justo non sagittis dictum, ex mauris tristique tellus, vitae mattis sem erat non augue. Donec quis nibh mollis, suscipit justo vel, laoreet purus. Duis ac metus id lacus dapibus cursus. Vestibulum eu ligula id tortor posuere viverra.
'''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Any initialization if needed
    _getPrivacyPolicy();
  }

  /// Open the privacy policy link in the browser.
  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(privacyUrl);
    try {
      // if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      //   Get.snackbar('Error', 'Could not open privacy policy');
      // }
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => PrivacyPolicyDialog(
          title: 'Privacy Policy',
          width: 716,
          height: 745,
          contentText: _sampleText.value,
          showAgreeButton: true,
          requireScrollToEnd: true,
          onAgree: () {
            // Set that user has agreed to privacy policy
            hasAgreedToPrivacy.value = true;
          },
          onClose: () {
            // optional
          },
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not open privacy policy');
    }
  }

  /// Called when the user taps "Agree & Continue".
  /// This toggles a loading state and then navigates to the next route.
  Future<void> agreeAndContinue() async {
    // Don't proceed if user hasn't agreed to privacy policy
    if (!hasAgreedToPrivacy.value) {
      Get.snackbar(
        'Privacy Policy Required',
        'Please read and agree to the privacy policy first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isLoading.value) return;
    isLoading.value = true;
    try {
      // simulate a small delay (e.g. setting permissions, preparing camera)
      await Future.delayed(const Duration(milliseconds: 700));

      // Navigate to the next page. Replace '/camera' with your real route.
      Get.toNamed(ScreenRoutes.ageQuestionScreen);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
  
  void _getPrivacyPolicy() async{
    try {
      final lang = Get.locale?.languageCode ?? 'en';
      final response = await _privacyPoliciesBl.getPrivacyPolicies(lang);
      
      if (response.content != "") {
        debugPrint('Privacy Policy fetched successfully');
        _sampleText.value = response.content ?? '';
        // You can store or display the fetched privacy policy as needed
      } else {
        debugPrint('Failed to fetch Privacy Policy');
      }
    } catch (e) {
      debugPrint('Error fetching Privacy Policy: $e');
    }
  }
}
