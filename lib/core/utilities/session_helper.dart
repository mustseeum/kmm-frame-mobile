import 'package:flutter/material.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/data/business_logic/login_bl.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/request/session/session_data_request.dart';

/// Helper class for session-related operations
class SessionHelper with CacheManager {
  final LoginBl _loginBl = LoginBl();

  /// Maps a screen key to a SessionParam enum value
  static SessionParam? mapKeyToSessionParam(String key) {
    switch (key.toLowerCase()) {
      case 'frame':
        return SessionParam.FRAME_ONLY;
      case 'lens':
        return SessionParam.LENS_ONLY;
      case 'both':
        return SessionParam.BOTH;
      default:
        return null;
    }
  }

  /// Gets session product and navigates to appropriate screen based on the session type
  Future<void> getSessionProductAndNavigate(String key, String lang) async {
    final sessionParam = mapKeyToSessionParam(key);

    if (sessionParam == null) {
      debugPrint('Invalid session key: $key');
      throw Exception('Invalid session key');
    }

    final sessionParamName = sessionParam.name;

    // Get user data and token
    final LoginDataModel? loginDM = await getUserData();
    final String token = loginDM?.access_token ?? '';

    // Create session request
    final SessionDataRequest sessionDataRequest = SessionDataRequest(
      activity_type: sessionParamName,
    );

    // Get session product
    final response = await _loginBl.getSessionProduct(
      sessionParamName,
      token,
      sessionDataRequest,
      lang,
    );

    debugPrint('Session Product Response: ${response.toString()}');

    // Validate response and navigate
    if (response != null && response.session_id != "") {
      _navigateBasedOnSessionType(sessionParam:sessionParam);
    } else {
      throw Exception('Failed to get session product');
    }
  }

  /// Navigates to the appropriate screen based on session type
  void _navigateBasedOnSessionType({SessionParam? sessionParam}) {
    switch (sessionParam) {
      case SessionParam.FRAME_ONLY:
        Navigation.navigateToWithArguments(
          ScreenRoutes.privacyIntroScreen,
          arguments: {'screenType': sessionParam?.name},
        );
        break;
      case SessionParam.LENS_ONLY:
        Navigation.navigateToWithArguments(
          ScreenRoutes.ageQuestionScreen,
          arguments: {'screenType': sessionParam?.name, 'firstScreen': 'frame'},
        );
        break;
      case SessionParam.BOTH:
        Navigation.navigateTo(ScreenRoutes.tryOnGlasses);
        break;
      default:
        debugPrint('Invalid or null session parameter');
        break;
    }
  }
}
