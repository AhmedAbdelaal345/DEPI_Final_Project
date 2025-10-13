import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final double widthRatio;

  DashedLinePainter({required this.widthRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2 * widthRatio
      ..style = PaintingStyle.stroke;

    final dashWidth = 5.0 * widthRatio;
    final dashSpace = 5.0 * widthRatio;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}