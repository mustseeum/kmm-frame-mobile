import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/controllers/sync_information_screen_controller.dart';

class SyncInformationScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => SyncInformationScreenController());
  }
}