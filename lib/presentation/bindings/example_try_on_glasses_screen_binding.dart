import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/glasses_try_on_example_controller.dart';

class ExampleTryOnGlassesScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => GlassesTryOnExampleController());
  }
}