import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FacePainter(this.faces, this.imageSize, {required bool isFrontCamera});

  @override
  void paint(Canvas canvas, Size size) {
    final contourPaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final boxPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (Face face in faces) {
      /// 🔲 FACE BOX
      final rect = Rect.fromLTRB(
        size.width - face.boundingBox.right * size.width / imageSize.width,
        face.boundingBox.top * size.height / imageSize.height,
        size.width - face.boundingBox.left * size.width / imageSize.width,
        face.boundingBox.bottom * size.height / imageSize.height,
      );
      canvas.drawRect(rect, boxPaint);

      /// 🔵 FACE CONTOURS (VIDEO LOOK)
      for (final contour in face.contours.values) {
        if (contour == null) continue;
        for (final point in contour.points) {
          final x = size.width -
              (point.x * size.width / imageSize.width);
          final y = point.y * size.height / imageSize.height;
          canvas.drawCircle(Offset(x, y), 2.5, contourPaint);
        }
      }

      /// 📐 FACE ANGLE BAR
      final yaw = face.headEulerAngleY ?? 0;

      canvas.drawLine(
        Offset(rect.center.dx - yaw, rect.bottom + 10),
        Offset(rect.center.dx + yaw, rect.bottom + 10),
        Paint()
          ..color = Colors.redAccent
          ..strokeWidth = 4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
  