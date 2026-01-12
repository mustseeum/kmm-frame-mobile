import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [BasePage Class]
/// Definition: An abstract class that extends StatelessWidget from Flutter.
/// Abstract Class: This class cannot be instantiated directly and is meant to be subclassed.
/// Purpose: Provides a base class for pages in a Flutter application that use GetX for state management. It standardizes the way pages interact with controllers and defines a common interface for page UI construction.
/// [Constructor]
/// const BasePage({super.key});
/// Definition: A constant constructor that allows optional key parameter for the StatelessWidget.
/// Purpose: The key parameter is used to preserve the state of the widget when the widget tree is rebuilt. The const keyword ensures that instances of BasePage are compile-time constants when the key is provided.
/// [controller Getter]
/// T get controller => Get.find<T>();
/// Definition: A getter that retrieves an instance of GetxController of type T.
/// Purpose: Provides an easy way to access the controller associated with the page. This leverages GetX’s dependency management to find and return the controller that has been registered.
/// [build Method]
/// @override Widget build(BuildContext context) { return buildPage(context); }
/// Definition: Overrides the build method from StatelessWidget.
/// Purpose: Calls the abstract method buildPage to construct the UI of the page. This method must be implemented by subclasses, providing a way to define the specific UI of the page while ensuring that build remains consistent.
/// [buildPage Method]
/// Widget buildPage(BuildContext context);
/// Definition: An abstract method that must be implemented by subclasses.
/// Purpose: Defines the actual UI for the page. Subclasses of BasePage must provide an implementation for this method, which will build and return the widget tree for the page.

// Abstract base class for pages in a Flutter application using GetX
abstract class BasePage<T extends GetxController> extends StatelessWidget {
  // Constructor for BasePage, allowing for optional key parameter
  const BasePage({super.key});

  // A getter to retrieve the GetxController of type T
  T get controller => Get.find<T>();

  // The build method required by StatelessWidget
  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }

  // Abstract method to be implemented by subclasses to define the page's UI
  Widget buildPage(BuildContext context);
}