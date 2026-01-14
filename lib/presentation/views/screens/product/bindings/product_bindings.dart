// Binding to inject repository and controller
import 'package:get/get.dart';
import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/data/repositories/product/product_repository.dart';
import 'package:kacamatamoo/presentation/views/screens/product/controllers/product_controllers.dart';

class ProductBinding extends Bindings {
  final dynamic initArgs; // optional arguments you may pass from page/routes

  ProductBinding({this.initArgs});

  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => ProductRepository(DioModule.getInstance()));
    Get.lazyPut<ProductControllers>(() => ProductControllers(Get.find<ProductRepository>()));
  }
}