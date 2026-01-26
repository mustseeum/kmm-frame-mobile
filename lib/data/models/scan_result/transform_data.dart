import 'dart:ui';

/// Output transform for overlay
class TransformData {
  final Offset center; // center in screen coords (px)
  final double rotation; // radians
  final double scale; // multiplier

  TransformData({
    required this.center,
    required this.rotation,
    required this.scale,
  });
}
