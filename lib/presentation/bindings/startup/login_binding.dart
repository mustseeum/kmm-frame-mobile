import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/controllers/login_screen_controller.dart';

class LoginScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => LoginScreenController());
  }
}