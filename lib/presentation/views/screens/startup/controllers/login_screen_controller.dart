import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utils/navigation_helper.dart';
import 'package:kacamatamoo/data/business_logic/login_bl.dart';
import 'package:kacamatamoo/data/models/request/login_data_request.dart';

class LoginScreenController extends BaseController {
  // Observable login state
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString userName = 'Guest'.obs;
  final LoginDataRequest loginRequest = LoginDataRequest();
  final LoginBl _loginBl = LoginBl();

  // Observable form fields
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  // Check if form is valid (both fields are not empty)
  bool get isFormValid => email.value.isNotEmpty && password.value.isNotEmpty;

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

      loginRequest.email = email;
      loginRequest.password = password;
      
      // Call login API using _loginBl
      final response = await _loginBl.loginUser(loginRequest);
      
      // Check if login was successful
      if (response?.success == true) {
        isLoggedIn.value = true;
      } else {
        throw Exception(response?.message ?? 'Login failed');
      }
      // navigate to start screen
      Navigation.navigateAndRemoveAll(ScreenRoutes.syncScreen);
    } catch (e) {
      // show error snackbar - in real app show localized friendly message
      Get.snackbar(
        'Login failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    userName.value = 'Guest';
    Get.offAllNamed(ScreenRoutes.login);
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
