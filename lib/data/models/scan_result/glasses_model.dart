import 'dart:ui';

class GlassesModel {
  final String id;
  final String assetImage;
  final double baseEyeDist;
  // Per-model tuning (pixels or normalized scale)
  final Offset anchorOffset; // x,y in pixels (applied after mapping)
  final double rotationOffsetDeg; // fine tune rotation
  final double scaleMultiplier; // multiply computed scale

  GlassesModel({
    required this.id,
    required this.assetImage,
    this.baseEyeDist = 60,
    this.anchorOffset = Offset.zero,
    this.rotationOffsetDeg = 0.0,
    this.scaleMultiplier = 1.0,
  });
}