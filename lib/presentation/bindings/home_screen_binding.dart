import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/home_screen_controller.dart';

class HomeScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => HomeScreenController());
  }
}