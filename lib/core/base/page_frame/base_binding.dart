import 'package:get/get.dart';

/// [BaseBinding Class]
/// Definition: An abstract class that extends Bindings from GetX. Bindings is a GetX class that provides a way to manage dependencies for a route.
/// Purpose: This class serves as a base class for setting up dependencies and handling route arguments.
/// [getArguments Method]
/// Definition: A method that returns a Map<String, dynamic>?.
/// Purpose: Calls extractArguments() to retrieve arguments passed to the route.
/// Returns: A map of arguments or null if no arguments are provided.
/// [handleArguments Method]
/// Definition: An abstract method with no implementation.
/// Purpose: This method is meant to be overridden by subclasses of BaseBinding to handle route-specific arguments.
/// Implementation: Subclasses should provide the actual implementation for how to handle the arguments.
/// [dependencies Method]
/// Definition: Overrides the dependencies method from the Bindings class.
/// Purpose: Calls handleArguments() to ensure that any necessary argument handling is performed when dependcies are set up for the route.
/// Implementation: This method is automatically called by GetX during route initialization, making it a key place for setup tasks related to dependencies and arguments.
/// [extractArguments Function]
/// Definition: A function that retrieves route arguments from GetX.
/// Purpose: Provides a utility to extract arguments passed to a route and cast them to Map<String, dynamic>?.
/// Returns: A map of arguments or null if the arguments are not of the expected type.

// An abstract class that extends Bindings from the GetX package
abstract class BaseBinding extends Bindings {
  // Method to retrieve arguments passed to the route
  Map<String, dynamic>? getArguments() {
    return extractArguments();
  }

  // Abstract method to handle arguments, to be implemented by subclasses
  void handleArguments();

  // Overriding the dependencies method from Bindings to call handleArguments
  @override
  void dependencies() {
    handleArguments();
  }
}

// Function to extract arguments from the GetX route
Map<String, dynamic>? extractArguments() {
  return Get.arguments as Map<String, dynamic>?;
}
