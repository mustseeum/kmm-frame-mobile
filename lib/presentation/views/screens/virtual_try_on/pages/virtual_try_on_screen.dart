import 'dart:io';

import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';
import 'package:kacamatamoo/data/models/glasses_model/filter_data.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_header_widget.dart';

class VirtualTryOnPage extends StatelessWidget {
  VirtualTryOnPage({super.key});
  final controller = Get.find<VirtualTryOnPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuestionHeader(
        showBack: false,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('Step 3 of 4', style: TextStyle(color: Colors.blue)),
        ),
      ),
      body: FutureBuilder<void>(
        future: controller.initializeDeepAr(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [buildCameraPreview(context), buildFilters(context)],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing AR...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget buildFilters(BuildContext context) => SizedBox(
  height: MediaQuery.of(context).size.height * 0.1,
  child: ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: filters.length,
    itemBuilder: (context, index) {
      final filter = filters[index];
      final effect = File(filter.filterPath).path;
      return GestureDetector(
        onTap: () {
          getDeepArController().switchEffect(effect);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundLight,
              image: DecorationImage(
                image: AssetImage(filter.imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    },
  ),
);

Widget buildCameraPreview(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final diameter = size.width < size.height
      ? size.width * 0.85
      : size.height * 0.85;

  return Center(
    child: SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        children: [
          SizedBox(
            width: diameter,
            height: diameter,
            child: DeepArPreview(getDeepArController()),
          ),
        ],
      ),
    ),
  );
}
