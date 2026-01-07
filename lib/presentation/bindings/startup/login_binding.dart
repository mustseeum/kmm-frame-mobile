import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/startup/login_screen_controller.dart';

class LoginScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => LoginScreenController());
  }
}