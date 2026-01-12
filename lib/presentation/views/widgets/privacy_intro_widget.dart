import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyIntroWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String firstInfoText;
  final String secondInfoText;
  final String privacyPolicyText;
  final String buttonText;
  final Color? iconColor;
  final Color? cardColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? buttonColor;
  final VoidCallback onAgree;
  final VoidCallback onPrivacyPolicyTap;
  final bool isLoading;

  const PrivacyIntroWidget({
    Key? key,
    this.title = '',
    this.subtitle = '',
    this.firstInfoText = '',
    this.secondInfoText = '',
    this.privacyPolicyText = '',
    this.buttonText = '',
    this.iconColor,
    this.cardColor,
    this.titleColor,
    this.subtitleColor,
    this.buttonColor,
    required this.onAgree,
    required this.onPrivacyPolicyTap,
    this.isLoading = false,
  }) : super(key: key);

  Widget _infoCard(BuildContext context, String text, Color cardColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Centered vertically and horizontally
  Widget _leftGraphic(Color iconColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.verified_user, size: 220, color: iconColor),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text('encrypted'.tr, style: TextStyle(color: iconColor)),
            const SizedBox(width: 20),
            Icon(Icons.visibility_off_outlined, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text('private'.tr, style: TextStyle(color: iconColor)),
          ],
        ),
      ],
    );
  }

  Widget _rightContent(
    BuildContext context,
    Color titleColor,
    Color subtitleColor,
    Color buttonColor,
    Color cardColor,
  ) {
    final titleText = title.isEmpty ? 'privacy_intro_title'.tr : title;
    final subtitleText = subtitle.isEmpty ? 'privacy_intro_subtitle'.tr : subtitle;
    final firstInfo = firstInfoText.isEmpty ? 'no_facial_recognition'.tr : firstInfoText;
    final secondInfo = secondInfoText.isEmpty ? 'no_storage_sharing'.tr : secondInfoText;
    final privacyText = privacyPolicyText.isEmpty ? 'read_privacy_policy'.tr : privacyPolicyText;
    final btnText = buttonText.isEmpty ? 'agree_continue'.tr : buttonText;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            text: titleText.split('privacy-friendly virtual try-on service')[0],
            style: TextStyle(fontSize: 22, color: subtitleColor),
            children: [
              if (titleText.contains('privacy-friendly virtual try-on service'))
                TextSpan(
                  text: 'privacy-friendly virtual try-on service',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: titleColor,
                  ),
                ),
              if (titleText.split('privacy-friendly virtual try-on service').length > 1)
                TextSpan(
                  text: titleText.split('privacy-friendly virtual try-on service')[1],
                  style: TextStyle(fontSize: 22, color: subtitleColor),
                ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subtitleText,
          style: TextStyle(fontSize: 16, color: subtitleColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        _infoCard(context, firstInfo, cardColor),
        const SizedBox(height: 16),
        _infoCard(context, secondInfo, cardColor),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: subtitleColor,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: privacyText.split('privacy policy')[0]),
                TextSpan(
                  text: 'privacy policy',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueAccent,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onPrivacyPolicyTap,
                ),
                if (privacyText.split('privacy policy').length > 1)
                  TextSpan(text: privacyText.split('privacy policy')[1]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onAgree,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        btnText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                const Icon(Icons.arrow_forward, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? const Color(0xFF083532);
    final defaultTitleColor = titleColor ?? const Color(0xFF0E3B39);
    final defaultSubtitleColor = subtitleColor ?? const Color(0xFF073233);
    final defaultButtonColor = buttonColor ?? const Color(0xFF072524);
    final defaultCardColor = cardColor ?? const Color(0xFFE6C94E);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _leftGraphic(defaultIconColor),
                        const SizedBox(height: 30),
                        _rightContent(
                          context,
                          defaultTitleColor,
                          defaultSubtitleColor,
                          defaultButtonColor,
                          defaultCardColor,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // center left graphic vertically
                      children: [
                        Expanded(
                          flex: 4,
                          child: _leftGraphic(defaultIconColor),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 6,
                          child: _rightContent(
                            context,
                            defaultTitleColor,
                            defaultSubtitleColor,
                            defaultButtonColor,
                            defaultCardColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
