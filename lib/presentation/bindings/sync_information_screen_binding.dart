import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/sync_information_screen_controller.dart';

class SyncInformationScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => SyncInformationScreenController());
  }
}