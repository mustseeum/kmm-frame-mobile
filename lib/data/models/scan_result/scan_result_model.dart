class ScanResultModel {
  final String faceShape;
  final String skinTone;
  final double faceWidth; // mm
  final double eyeWidth; // mm
  final double eyeLength;
  final double eyeHeight;
  final double bridge;
  final double templeLength;
  final String suggestedFrame;
  final String suggestedColor;
  final String imagePath; // local asset or file path or network

  ScanResultModel({
    required this.faceShape,
    required this.skinTone,
    required this.faceWidth,
    required this.eyeWidth,
    required this.eyeLength,
    required this.eyeHeight,
    required this.bridge,
    required this.templeLength,
    required this.suggestedFrame,
    required this.suggestedColor,
    required this.imagePath,
  });
}