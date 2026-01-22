import 'package:flutter/material.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/presentation/views/widgets/custom_dialog_widget.dart';

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
  final Widget?
  trailing; // if you want a custom trailing widget instead of stepText
  final double titleSpacing;
  final bool showDivider;
  final Color? dividerColor;
  final double dividerHeight;
  final double? fontSize;
  final FontWeight? fontWeight;

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
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: elevation,
                      offset: Offset(0, elevation / 2),
                    ),
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
                GestureDetector(
                  onTap: () {
                    // Handle logo tap if needed
                    _showEndSessionDialog(context);
                  },
                  child: Image.asset(
                    logoPath ?? AssetsConstants.imageLogo,
                    height: 20,
                    fit: BoxFit.contain,
                    // Provide semantic label if needed
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Center(
                    child:
                        trailing ??
                        Text(
                          stepText ?? '',
                          style: TextStyle(
                            color: Color(0xFF2B3A39),
                            fontSize: fontSize,
                            fontWeight: fontWeight,
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

void _showEndSessionDialog(BuildContext context) async {
  final result = await CustomDialogWidget.show(
    context: context,
    title: 'End Session',
    content: 'Are you sure you want to end\nthe current session?',
    iconAssetPath:
        AssetsConstants.warningAlert, // Or use iconAssetPath for custom icon
    iconBackgroundColor: const Color(0xFFFEE4E2),
    iconColor: const Color(0xFFD92D20),
    primaryButtonText: 'End Session',
    secondaryButtonText: 'Cancel',
    primaryButtonColor: const Color(0xFFD92D20),
    onPrimaryPressed: () {
      Navigator.of(context).pop(true);
      // Handle end session logic here
      print('Session ended');
    },
    onSecondaryPressed: () {
      Navigator.of(context).pop(false);
      print('Cancelled');
    },
  );

  if (result == true) {
    // User confirmed - clear navigation stack and go to home
    // User cannot go back to previous screens, only forward to other screens
    Navigation.navigateAndRemoveAll(ScreenRoutes.home);
    print('Session ended - navigation stack cleared');
  }
}
