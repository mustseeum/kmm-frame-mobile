import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_controller.dart';

class VirtualTryOnPageBinding extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => VirtualTryOnPageController());
  }
}