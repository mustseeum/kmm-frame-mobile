import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/store_information_pages/controller/sync_information_screen_controller.dart';

class SyncInformationScreenBinding extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => SyncInformationScreenController());
  }
}