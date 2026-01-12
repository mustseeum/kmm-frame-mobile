import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_controller.dart';

class VirtualTryOnPageBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => VirtualTryOnPageController());
  }
}