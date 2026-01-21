import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';

/// Reusable header widget as a Container.
/// Example:
///   QuestionHeader(stepText: 'Step 1 of 4')
class QuestionHeader extends StatelessWidget {
  final String? logoPath;
  final String? stepText;
  final Color backgroundColor;
  final double elevation;
  final double height;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing; // if you want a custom trailing widget instead of stepText
  final double titleSpacing;
  final bool showDivider;
  final Color? dividerColor;
  final double dividerHeight;

  const QuestionHeader({
    super.key,
    this.logoPath, // Replace with actual path or use a const from AssetsConstants
    this.stepText,
    this.backgroundColor = Colors.white,
    this.elevation = 0.6,
    this.height = 80.0,
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.titleSpacing = 24.0,
    this.showDivider = true,
    this.dividerColor,
    this.dividerHeight = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: elevation,
                      offset: Offset(0, elevation / 2),
                    )
                  ]
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: titleSpacing),
            child: Row(
              children: [
                if (showBack)
                  IconButton(
                    onPressed: onBack ?? () => Navigator.maybePop(context),
                    icon: Icon(Icons.arrow_back, color: AppColors.p900),
                  ),
                // Use Image.asset for your logo (ensure asset exists and is registered in pubspec.yaml)
                Image.asset(
                  logoPath ?? AssetsConstants.imageLogo,
                  height: 20,
                  fit: BoxFit.contain,
                  // Provide semantic label if needed
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Center(
                    child: trailing ??
                        Text(
                          stepText ?? '',
                          style: const TextStyle(
                            color: Color(0xFF0E2546),
                            fontSize: 13,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: dividerHeight,
            color: dividerColor ?? const Color(0xFF2AA6A6),
          ),
      ],
    );
  }
}