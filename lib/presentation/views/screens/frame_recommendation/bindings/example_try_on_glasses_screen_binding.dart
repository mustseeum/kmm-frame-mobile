import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/glasses_try_on_example_controller.dart';

class ExampleTryOnGlassesScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => GlassesTryOnExampleController());
  }
}