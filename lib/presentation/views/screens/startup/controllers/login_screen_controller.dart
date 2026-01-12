import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utils/navigation_helper.dart';

class LoginScreenController extends BaseController {
  // Observable login state
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString userName = 'Guest'.obs;

  // Simple demo login - replace with your backend auth
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      // simulate network call
      await Future.delayed(const Duration(seconds: 1));
      // simple validation example
      if (email.isEmpty || password.length < 6) {
        throw Exception('Invalid credentials');
      }
      // set user display name from email
      final name = email.split('@').first;
      userName.value = _capitalize(name);
      isLoggedIn.value = true;
      // navigate to start screen
      Navigation.navigateAndRemoveAll('/syncScreen');
    } catch (e) {
      // show error snackbar - in real app show localized friendly message
      Get.snackbar('Login failed', e.toString(),
        snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    userName.value = 'Guest';
    Get.offAllNamed('/');
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}