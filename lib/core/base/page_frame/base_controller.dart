import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/http_connection/base_repo.dart';

/// [BaseController Class]
/// Definition: An abstract class extending GetxController from the GetX package.
/// Purpose: Serves as a base class for controllers that interact with repositories and handle route arguments. It includes common properties and methods useful for controllers.
/// [repository Field]
/// final R? repository;
/// - Definition: A field to hold an instance of a repository of type R, which extends BaseRepo.
/// - Purpose: To provide access to data and business logic encapsulated in the repository. The repository is optional and can be null.
/// [Constructor]
/// `BaseController([this.repository]);`
/// - Definition: A constructor that optionally accepts a repository.
/// - Purpose: Initializes the repository field. The square brackets indicate that the repository parameter is optional.
/// [Reactive Properties]
/// RxBool isLoading = false.obs;
/// - Definition: A reactive boolean property to track the loading state.
/// - Purpose: Allows the UI to reactively update based on whether data is being loaded.
/// RxString errorMessage = ''.obs;
/// - Definition: A reactive string property to store error messages.
/// - Purpose: Allows the UI to reactively display error messages when something goes wrong.
/// [handleArguments Method]
/// void handleArguments(Map<String, dynamic> arguments);
/// - Definition: An abstract method that must be implemented by subclasses.
/// - Purpose: To define how the controller should process and handle arguments passed to the route. This ensures that each specific controller can handle arguments according to its needs.
/// onInit Method:
/// `@override void onInit() { ... }`
/// - Definition: Overrides the onInit method from GetxController.
/// - Purpose: Provides initialization logic. In this implementation, it retrieves route arguments and passes them to handleArguments if they are available.
/// Implementation:
/// - final arguments = Get.arguments as Map<String, dynamic>?;
///   - Retrieves route arguments from GetX and casts them to Map<String, dynamic>?.
/// - if (arguments != null && arguments.isNotEmpty) { handleArguments(arguments); }
///   - Checks if arguments are present and not empty, then calls handleArguments to process them.

// Abstract class for controllers in the GetX architecture
abstract class BaseController<R extends BaseRepo?> extends GetxController {
  // Repository associated with this controller
  final R? repository;

  // Constructor for BaseController, optionally accepting a repository
  BaseController([this.repository]);

  // Reactive boolean to track loading state
  RxBool isLoading = false.obs;

  // Reactive string to hold error messages
  RxString errorMessage = ''.obs;

  // Abstract method to handle route arguments
  void handleArguments(Map<String, dynamic> arguments);

  // Override onInit to handle initialization logic
  @override
  void onInit() {
    super.onInit();

    // Extract and handle route arguments if available
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.isNotEmpty) {
      handleArguments(arguments);
    }
  }
}
