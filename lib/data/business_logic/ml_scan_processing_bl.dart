import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers_data_request.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_scan_processing_dm.dart';
import 'package:kacamatamoo/data/repositories/scan_result/ml_scan_processing_repository.dart';

class MLScanProcessingBl with CacheManager{
  MLScanProcessingRepository repository = MLScanProcessingRepository(DioModule.getInstance());

  Future<MLScanProcessingDm?> processFaceScan(AnswersDataRequest answersDataRequest) async {
    // Simulate network call delay
    await Future.delayed(const Duration(seconds: 2));
    final LoginDataModel loginDataModel = await getUserData();
    String token = loginDataModel.access_token ?? "";

    MLScanProcessingDm mlScanProcessingDm = MLScanProcessingDm();
    ParentResponse? response = await repository.processFaceScan(answersDataRequest, token);
    bool success = response?.success ?? false;
    if (success) {
      mlScanProcessingDm = response?.data ?? MLScanProcessingDm();
      return mlScanProcessingDm;
    } else {
      return null;
    }
  }
  
}