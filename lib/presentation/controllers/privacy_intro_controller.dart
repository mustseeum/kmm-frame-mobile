import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyIntroController extends GetxController {
  // Loading state for the Agree button (e.g., show spinner or disable)
  final isLoading = false.obs;

  // URL for the privacy policy; replace with your real link
  final String privacyUrl = 'https://example.com/privacy';

  /// Open the privacy policy link in the browser.
  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(privacyUrl);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not open privacy policy');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open privacy policy');
    }
  }

  /// Called when the user taps "Agree & Continue".
  /// This toggles a loading state and then navigates to the next route.
  Future<void> agreeAndContinue() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      // simulate a small delay (e.g. setting permissions, preparing camera)
      await Future.delayed(const Duration(milliseconds: 700));

      // Navigate to the next page. Replace '/camera' with your real route.
      Get.toNamed(ScreenRoutes.tryOnGlasses);
    } finally {
      isLoading.value = false;
    }
  }
}