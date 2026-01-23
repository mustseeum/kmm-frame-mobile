import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/http_connection/base_result.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/presentation/views/widgets/custom_dialog_widget.dart';

class RequestHelper with CacheManager {
  Future<ParentResponse?> generateErrorResponse(String message) async {
    ParentResponse parentResponse = ParentResponse();
    parentResponse.message = message;
    return parentResponse;
  }

  Future<ParentResponse?> responseHandler({
    BaseResult? response,
    required Function onSuccess,
    required Function onRedirection,
    required Function onUnprocessableEntity,
    required Function onError,
    required Function onUnreachable,
    required Function onDefault,
    required Function unauthenticated,
  }) async {
    // bool useDummy = await getUseDummy();
    // if (useDummy) {
    // return onSuccess();
    // } else {
    switch (response?.status) {
      case ResponseStatus.Success:
        return onSuccess();
      case ResponseStatus.unauthenticated:
        return unauthenticated();
      case ResponseStatus.Error:
        return onError();
      case ResponseStatus.Unreachable:
        return onUnreachable();
      default:
        return onDefault();
    }
    // }
  }

  Future<bool> unAuthenticated(int? statusCode, String? statusMessage) async {
    if (statusCode == 401) {
      debugPrint("Unauthorized User - $statusMessage");

      // Show dialog to inform user about unauthorized access
      // await Get.dialog(
      //   AlertDialog(
      //     title: const Text("Session Expired"),
      //     content: Text(
      //       statusMessage ?? "Your session has expired. Please login again.",
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () async {
      //           // Close dialog
      //           Get.back();

      //           // Clear all auth data
      //           await clearAuthData();

      //           // Navigate to login screen
      //           Navigation.navigateAndRemoveAll(ScreenRoutes.login);
      //         },
      //         child: const Text("OK"),
      //       ),
      //     ],
      //   ),
      //   barrierDismissible: false,
      // );

      await CustomDialogWidget.show(
        context: Get.context!,
        title: 'Session Expired !',
        content:
            statusMessage ?? "Your session has expired. Please login again.",
        iconAssetPath: AssetsConstants.roundedError,
        primaryButtonText: 'OK',
        primaryButtonColor: AppColors.primary,
        onPrimaryPressed: () async {
          // Close dialog
          Get.back();

          // Clear all auth data
          await clearAuthData();

          // Navigate to login screen
          Navigation.navigateAndRemoveAll(ScreenRoutes.login);
        },
      );

      return true;
    }
    return false;
  }

  Future<bool> apiLevelNotMatch(String message) async {
    Get.dialog(
      AlertDialog(
        title: Text("Halo !"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Navigation.goBack();
              // await Helpers().doLogout();
            },
            child: Text("Update"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return true;
  }

  Future<bool> showError(String errorMessage) async {
    String message = errorMessage.capitalize ?? "Silahkan hubungi admin";
    await CustomDialogWidget.show(
      context: Get.context!,
      title: 'Ooops !',
      content: message,
      iconAssetPath: AssetsConstants.roundedError,
      primaryButtonText: 'OK',
      primaryButtonColor: AppColors.primary,
      onPrimaryPressed: () {
        Navigator.of(Get.context!).pop(true);
        // Handle logout logic here
      },
      onSecondaryPressed: () {
        Navigator.of(Get.context!).pop(false);
        debugPrint('Cancelled');
      },
    );
    return true;
  }
}
