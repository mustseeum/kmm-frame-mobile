import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';

/// Reusable header widget to be used as `appBar`.
/// Example:
///   appBar: QuestionHeader(stepText: 'Step 1 of 4')
class QuestionHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? logoPath;
  final String? stepText;
  final Color backgroundColor;
  final double elevation;
  final double height;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing; // if you want a custom trailing widget instead of stepText
  final double titleSpacing;

  const QuestionHeader({
    super.key,
    this.logoPath, // Replace with actual path or use a const from AssetsConstants
    this.stepText,
    this.backgroundColor = Colors.white,
    this.elevation = 0.6,
    this.height = 72.0,
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.titleSpacing = 24.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      titleSpacing: titleSpacing,
      toolbarHeight: height,
      // leading: showBack
      //     ? IconButton(
      //         onPressed: onBack ?? () => Navigator.maybePop(context),
      //         icon: const Icon(Icons.arrow_back, color: AppColors.onSecondaryContainerLight),
      //       )
      //     : null,
      title: Row(
        children: [
          // Use Image.asset for your logo (ensure asset exists and is registered in pubspec.yaml)
          Image.asset(
            logoPath??AssetsConstants.imageLogo,
            height: 20,
            fit: BoxFit.contain,
            // Provide semantic label if needed
          ),
        ],
      ),
      actions: [
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
        )
      ],
    );
  }
}