import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';

class HeadingCardWidget extends StatelessWidget {
  final double containerWidth;
  final bool isTablet;
  final VoidCallback? onTap;
  final VoidCallback? onPress;

  const HeadingCardWidget({
    super.key,
    required this.containerWidth,
    required this.isTablet,
    this.onTap,
    this.onPress,
  });

  void _handleTap() {
    // Call onTap if provided, otherwise call onPress if provided
    if (onTap != null) {
      onTap!();
    } else if (onPress != null) {
      onPress!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onTap != null || onPress != null) ? _handleTap : null,
      child: Container(
        width: containerWidth.clamp(320.0, 720.0),
        padding: EdgeInsets.all(isTablet ? 30 : 20),
        margin: EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetsConstants.imageLogo,
              width: isTablet ? 300 : 100,
              height: isTablet ? 29 : 100,
            ),
            const SizedBox(height: 12),
            Text(
              'ai_powered'.tr,
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
