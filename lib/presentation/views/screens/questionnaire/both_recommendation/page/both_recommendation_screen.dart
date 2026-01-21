import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';

class BothRecommendationScreen extends BasePage {
  const BothRecommendationScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    // TODO: implement buildPage
    return Scaffold(
      appBar: AppBar(
        title: const Text('Both Recommendation Screen'),
      ),
      body: const Center(
        child: Text('Content goes here'),
      ),
    );
  }
}
