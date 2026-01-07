import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/startup/sync_information_screen_controller.dart';

class SyncInformationScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => SyncInformationScreenController());
  }
}