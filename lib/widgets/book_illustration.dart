import 'package:flutter/material.dart';
import 'dart:math' as math;

class BookIllustration extends StatelessWidget {
  final double size;
  final Color color;

  const BookIllustration({
    super.key,
    this.size = 150,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: BookPainter(color: color),
    );
  }
}

class BookPainter extends CustomPainter {
  final Color color;

  BookPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;

    // Draw open book
    final bookPath = Path();
    
    // Left page
    bookPath.moveTo(width * 0.2, height * 0.3);
    bookPath.lineTo(width * 0.2, height * 0.7);
    bookPath.quadraticBezierTo(
      width * 0.3, height * 0.75,
      width * 0.5, height * 0.75,
    );
    bookPath.lineTo(width * 0.5, height * 0.3);
    bookPath.close();

    // Right page
    bookPath.moveTo(width * 0.5, height * 0.3);
    bookPath.lineTo(width * 0.5, height * 0.75);
    bookPath.quadraticBezierTo(
      width * 0.7, height * 0.75,
      width * 0.8, height * 0.7,
    );
    bookPath.lineTo(width * 0.8, height * 0.3);
    bookPath.close();

    // Center binding
    bookPath.moveTo(width * 0.5, height * 0.25);
    bookPath.lineTo(width * 0.5, height * 0.8);

    // Coffee cup
    final cupPath = Path();
    cupPath.moveTo(width * 0.65, height * 0.25);
    cupPath.lineTo(width * 0.65, height * 0.35);
    cupPath.lineTo(width * 0.75, height * 0.35);
    cupPath.lineTo(width * 0.75, height * 0.25);
    
    // Cup handle
    cupPath.addArc(
      Rect.fromLTWH(width * 0.75, height * 0.27, width * 0.08, height * 0.06),
      -math.pi / 2,
      math.pi,
    );

    // Steam lines
    final steamPath = Path();
    steamPath.moveTo(width * 0.68, height * 0.18);
    steamPath.quadraticBezierTo(
      width * 0.67, height * 0.22,
      width * 0.68, height * 0.24,
    );
    
    steamPath.moveTo(width * 0.72, height * 0.16);
    steamPath.quadraticBezierTo(
      width * 0.71, height * 0.20,
      width * 0.72, height * 0.24,
    );

    canvas.drawPath(bookPath, paint);
    canvas.drawPath(cupPath, paint);
    canvas.drawPath(steamPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
