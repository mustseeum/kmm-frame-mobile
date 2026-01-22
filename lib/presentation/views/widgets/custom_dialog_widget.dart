import 'package:flutter/material.dart';

class CustomDialogWidget extends StatelessWidget {
  final String?  title;
  final String? content;
  final String? iconAssetPath;
  final IconData? iconData;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String? primaryButtonText;
  final String?  secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback?  onSecondaryPressed;
  final Color? primaryButtonColor;
  final Color?  primaryButtonTextColor;
  final Color? secondaryButtonColor;
  final Color? secondaryButtonTextColor;
  final bool barrierDismissible;

  const CustomDialogWidget({
    super.key,
    this. title,
    this.content,
    this.iconAssetPath,
    this.iconData,
    this.iconBackgroundColor,
    this.iconColor,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this. primaryButtonColor,
    this. primaryButtonTextColor,
    this.secondaryButtonColor,
    this.secondaryButtonTextColor,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        width: 400,
        height: 268,
        padding: const EdgeInsets. all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Section
                if (iconAssetPath != null || iconData != null)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? 
                             const Color(0xFFFEE4E2), // Light red background
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: iconAssetPath != null
                          ?  Image.asset(
                              iconAssetPath!,
                              width: 24,
                              height: 24,
                              color: iconColor ?? const Color(0xFFD92D20),
                            )
                          :  Icon(
                              iconData ??  Icons.error_outline,
                              color: iconColor ?? const Color(0xFFD92D20),
                              size: 24,
                            ),
                    ),
                  ),
                
                if (iconAssetPath != null || iconData != null)
                  const SizedBox(height: 16),

                // Title Section
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828),
                    ),
                    textAlign: TextAlign.center,
                  ),

                if (title != null && content != null)
                  const SizedBox(height: 8),

                // Content Section
                if (content != null)
                  Text(
                    content! ,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:  FontWeight.w400,
                      color: Color(0xFF667085),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),

            // Buttons Section
            Row(
              children: [
                // Secondary Button
                if (secondaryButtonText != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondaryPressed ??  
                                () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: secondaryButtonColor ?? 
                                const Color(0xFFD0D5DD),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        secondaryButtonText!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:  FontWeight.w600,
                          color: secondaryButtonTextColor ?? 
                                const Color(0xFF344054),
                        ),
                      ),
                    ),
                  ),

                if (secondaryButtonText != null && primaryButtonText != null)
                  const SizedBox(width: 12),

                // Primary Button
                if (primaryButtonText != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPrimaryPressed ?? 
                                () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets. symmetric(vertical: 12),
                        backgroundColor: primaryButtonColor ??  
                                       const Color(0xFFD92D20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius. circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        primaryButtonText!,
                        style:  TextStyle(
                          fontSize:  16,
                          fontWeight: FontWeight.w600,
                          color: primaryButtonTextColor ?? Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Static method to show the dialog
  static Future<bool? > show({
    required BuildContext context,
    String? title,
    String? content,
    String? iconAssetPath,
    IconData? iconData,
    Color? iconBackgroundColor,
    Color? iconColor,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Color? primaryButtonColor,
    Color? primaryButtonTextColor,
    Color? secondaryButtonColor,
    Color?  secondaryButtonTextColor,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          title:  title,
          content: content,
          iconAssetPath: iconAssetPath,
          iconData: iconData,
          iconBackgroundColor: iconBackgroundColor,
          iconColor: iconColor,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          onPrimaryPressed: onPrimaryPressed,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonColor: primaryButtonColor,
          primaryButtonTextColor: primaryButtonTextColor,
          secondaryButtonColor: secondaryButtonColor,
          secondaryButtonTextColor: secondaryButtonTextColor,
          barrierDismissible: barrierDismissible,
        );
      },
    );
  }
}