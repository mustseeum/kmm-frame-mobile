import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/controllers/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}
