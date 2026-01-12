import 'dart:math';
import 'package:flutter/material.dart';

/// A custom painter that draws a circular ring with progress indication.
///
/// This painter draws a border circle and optionally an arc showing progress
/// from 0.0 to 1.0. The progress arc is drawn on top of the border with a
/// slightly thicker stroke and rounded caps.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: RingPainter(
///     progress: 0.5,
///     borderColor: Colors.grey,
///     progressColor: Colors.blue,
///     strokeWidth: 3.0,
///   ),
/// )
/// ```
class RingPainter extends CustomPainter {
  /// The progress value from 0.0 to 1.0 representing how much of the ring
  /// should be filled.
  final double progress;

  /// The color of the background ring border.
  final Color borderColor;

  /// The color of the progress arc that fills the ring.
  final Color progressColor;

  /// The width of the strokes. The border uses this width, and the progress
  /// arc uses this width + 2.0 for a slightly bolder appearance.
  final double strokeWidth;

  /// Optional cap style for the progress arc. Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  /// Optional starting angle for the progress arc in radians.
  /// Defaults to -π/2 (top of the circle, 12 o'clock position).
  final double startAngle;

  /// Creates a [RingPainter].
  ///
  /// All parameters except [strokeCap] and [startAngle] are required.
  RingPainter({
    required this.progress,
    required this.borderColor,
    required this.progressColor,
    this.strokeWidth = 3.0,
    this.strokeCap = StrokeCap.round,
    this.startAngle = -pi / 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (min(size.width, size.height) / 2) - strokeWidth;

    // Draw the border circle (background ring)
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = borderColor;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw the progress arc if progress > 0
    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 2.0
        ..strokeCap = strokeCap
        ..color = progressColor;

      final sweepAngle = 2 * pi * (progress.clamp(0.0, 1.0));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.startAngle != startAngle;
  }
}
