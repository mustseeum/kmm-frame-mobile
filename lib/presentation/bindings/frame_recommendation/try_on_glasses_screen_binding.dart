import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/frame_recommendation/try_on_glasses_controller.dart';

class TryOnGlassesScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => TryOnGlassesController());
  }
}