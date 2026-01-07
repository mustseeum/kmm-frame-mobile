import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';

class AgeController extends GetxController {
  // Options to display (strings)
  final options = <String>[
    '6-17 years old',
    '18-39 years old',
    '40-50 years old',
    '51+ years old',
  ];

  // Index of selected option (-1 means none)
  final selectedIndex = (-1).obs;

  void select(int idx) {
    if (selectedIndex.value == idx) {
      selectedIndex.value = -1; // toggle off when tapped again (optional)
    } else {
      selectedIndex.value = idx;
      // debugPrint('Selected age option: ${options[idx]}');
      Get.toNamed(ScreenRoutes.wearPurposeScreen);
    }
  }

  String? get selectedOption =>
      (selectedIndex.value >= 0 ? options[selectedIndex.value] : null);
}
