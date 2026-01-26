import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/login_pages/controller/login_screen_controller.dart';

class LoginScreenBinding extends BaseBinding{
  // @override
  // void dependencies(){
  //   Get.lazyPut(() => LoginScreenController());
  // }
  @override
  void handleArguments() {
    // TODO: implement handleArguments
    Get.lazyPut(() => LoginScreenController());
  }
}