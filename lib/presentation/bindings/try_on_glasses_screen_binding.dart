import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/try_on_glasses_controller.dart';

class TryOnGlassesScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => TryOnGlassesController());
  }
}