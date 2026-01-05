import 'package:flutter/material.dart';

class OptionTilteWidget extends StatelessWidget {
  final Color background;
  final String assetIcon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionTilteWidget({
    super.key,
    required this.background,
    required this.assetIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // tile height tuned for tablet vertical look
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          child: Row(
            children: [
              // Icon
              Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(assetIcon, fit: BoxFit.contain),
              ),
              const SizedBox(width: 16),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF0B1314))),
                  ],
                ),
              ),
              // Arrow
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF0B1314)),
            ],
          ),
        ),
      ),
    );
  }
}