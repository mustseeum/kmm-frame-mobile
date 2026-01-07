import 'package:flutter/material.dart';

class CircleOverlayWidget extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;

  const CircleOverlayWidget({
    super.key,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CirclePainter(
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: Container(),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;

  _CirclePainter({required this.borderColor, required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        (size.width < size.height ? size.width : size.height) / 2 - borderWidth;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
