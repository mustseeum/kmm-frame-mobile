import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/data_user.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/request/login_data_request.dart';
import 'package:kacamatamoo/data/repositories/auth/login_repositories.dart';

class LoginBl with CacheManager {
  final LoginRepositories _repository = LoginRepositories(
    DioModule.getInstance(),
  );

  /// Call login API with email and password
  Future<ParentResponse?> loginUser(LoginDataRequest request) async {
    try {
      final LoginDataModel dataModel = LoginDataModel();
      final response = await _repository.loginUser(request);

      if (response?.success == true) {
        dataModel.access_token = response?.data['access_token'];
        dataModel.refresh_token = response?.data['refresh_token'];
        dataModel.user = DataUser.fromJson(response?.data['user'] ?? {});
        // Save authentication data to cache
        await saveLoginStatus(true);
        // Save token if exists in response
        if (response?.data != null && response?.data['token'] != null) {
          await saveAuthToken(dataModel.access_token ?? '');
        }

        // Save user data if exists in response
        if (response?.data != null) {
          await saveUserData(dataModel);
        }
      } else {
        throw Exception(response?.message ?? 'Login failed');
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
