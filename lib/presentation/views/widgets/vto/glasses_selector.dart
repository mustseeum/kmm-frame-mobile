import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_v2_controller.dart';

class GlassesSelector extends StatelessWidget {
  final VirtualTryOnV2Controller controller;
  const GlassesSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Obx(() {
        final list = controller.glasses;
        final selected = controller.selectedGlasses.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: list.length,
          itemBuilder: (context, idx) {
            final g = list[idx];
            final isSel = selected?.id == g.id;
            return GestureDetector(
              onTap: () => controller.selectGlasses(g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSel ? Colors.blueAccent.withOpacity(0.9) : Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(g.assetImage, width: 64, height: 64),
              ),
            );
          },
        );
      }),
    );
  }
}