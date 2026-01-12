import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';

class WearPurposeController extends GetxController {
  // Options to display (strings)
  final options = <String>[
    'Man Eyewear',
    'Women Eyewear',
  ];

  // Index of selected option (-1 means none)
  final selectedIndex = (-1).obs;

  void select(int idx) {
    if (selectedIndex.value == idx) {
      selectedIndex.value = -1; // toggle off when tapped again (optional)
    } else {
      selectedIndex.value = idx;
      debugPrint('Selected age option: ${options[idx]}');
      Get.toNamed(ScreenRoutes.scanningFaceScreen);
    }
  }

  String? get selectedOption =>
      (selectedIndex.value >= 0 ? options[selectedIndex.value] : null);
}