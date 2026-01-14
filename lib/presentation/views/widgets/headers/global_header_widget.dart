import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';

class GlobalHeader extends StatelessWidget implements PreferredSizeWidget {
  const GlobalHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors adapted from your screenshot
    final borderColor = Color(0xFF9ED7D0);
    final textColor = Color(0xFF2B3A39);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 2),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Replace with your logo asset
            Image.asset(
              AssetsConstants.imageLogo,
              height: 20,
              fit: BoxFit.contain,
            ),
            Spacer(),
            Text(
              'AI–Powered Virtual Try On System',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}