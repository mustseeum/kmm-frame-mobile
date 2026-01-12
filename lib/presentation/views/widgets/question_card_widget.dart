import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';

class QuestionCardWidget extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  const QuestionCardWidget({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.fountainBlue50 : Colors.transparent;
    final shadow = selected
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: const Offset(0, 6),
              blurRadius: 12,
            )
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 8,
            )
          ];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: shadow,
            border: Border.all(color: borderColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0E2546),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}