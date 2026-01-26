import 'package:kacamatamoo/data/models/scan_result/ml_result_data/measurements_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/recommended_frames_dm.dart';

class ScanResultModel {
  final double confidenceLevel;
  final String faceShape;
  final String imageId;
  final MeasurementsDm measurements;
  final RecommendedFramesDm recommendedFrames;
  final String sessionId;
  final String skinTone;
  final String imagePath;

  ScanResultModel({
    required this.confidenceLevel,
    required this.faceShape,
    required this.imageId,
    required this.measurements,
    required this.recommendedFrames,
    required this.sessionId,
    required this.skinTone,
    required this.imagePath,
  });
}
