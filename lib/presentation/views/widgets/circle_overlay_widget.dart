import 'package:flutter/material.dart';

class CircleOverlayWidget extends StatelessWidget {
  final Rect circleRect;
  final double borderWidth;
  final Color borderColor;

  const CircleOverlayWidget({
    super.key,
    required this.circleRect,
    this.borderWidth = 3.0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _CircleOverlayWidgetPainter(circleRect: circleRect, borderWidth: borderWidth, borderColor: borderColor),
      ),
    );
  }
}

class _CircleOverlayWidgetPainter extends CustomPainter {
  final Rect circleRect;
  final double borderWidth;
  final Color borderColor;

  _CircleOverlayWidgetPainter({
    required this.circleRect,
    required this.borderWidth,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // dim background
    final paint = Paint()..color = Colors.black.withOpacity(0.35);
    canvas.drawRect(Offset.zero & size, paint);

    // clear inside circle (make transparent)
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;
    canvas.saveLayer(Offset.zero & size, Paint()); // required for clear
    canvas.drawCircle(circleRect.center, circleRect.width / 2, clearPaint);

    canvas.restore();

    // draw border
    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(circleRect.center, circleRect.width / 2, border);
  }

  @override
  bool shouldRepaint(covariant _CircleOverlayWidgetPainter oldDelegate) {
    return oldDelegate.circleRect != circleRect;
  }
}