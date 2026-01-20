import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/question_controller.dart';
import 'package:kacamatamoo/data/repositories/question_recommendation/question_recommendation_repository.dart';

class QuestionBindings extends BaseBinding {
  @override
  void handleArguments() {
    // Bind the repository first (no-arg constructor)
    Get.lazyPut<QuestionRecommendationRepository>(() => QuestionRecommendationRepository(DioModule.getInstance()));

    // Then bind the controller which will receive the repository via DI
    Get.lazyPut<QuestionController>(() => QuestionController(repository: Get.find()));
  }
}