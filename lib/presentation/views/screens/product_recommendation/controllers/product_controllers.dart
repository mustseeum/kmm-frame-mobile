import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/data/models/data_response/products/product_data_model.dart';

class ProductControllers extends BaseController {
  // observable list of products
  final RxList<ProductDataModel> products = <ProductDataModel>[].obs;

  // currently selected product for details/confirmation
  final Rxn<ProductDataModel> selected = Rxn<ProductDataModel>();

  // loading state
  final RxBool isLoading = false.obs;

  // applied type filter (nullable means both/all)
  final Rxn<ProductType> filterType = Rxn<ProductType>();

  ProductControllers(super.repository);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // loadProducts();
  }

  // Future<void> loadProducts({ProductType? type}) async {
  //   isLoading.value = true;
  //   final list = await repository.fetchByType(type);
  //   products.assignAll(list);
  //   filterType.value = type ?? ProductType.both;
  //   isLoading.value = false;
  // }

  void applyTypeFilter(ProductType? type) {
    // loadProducts(type: type);
  }

  void selectProduct(ProductDataModel product) {
    selected.value = product;
  }

  void clearSelection() {
    selected.value = null;
  }

  Future<void> confirmSelection() async {
    // In real app: do navigation to report card or send selection to server.
    // For demo, we just keep the selection and maybe return.
    await Future.delayed(const Duration(milliseconds: 250));
    // Keep this method for potential side effects.
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
