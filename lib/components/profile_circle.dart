import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCircle extends StatelessWidget {
  const ProfileCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FourArcsPainter(),
      child: Container(
        width: 120.w, // circle size
        height: 120.w,
        decoration: const BoxDecoration(
          color: Color(0xFFFFE9DD), // light peach fill
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _FourArcsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF65E00) // orange border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    const arcLength = pi / 5; // small arc size (adjust this to make longer/shorter)
    for (int i = 0; i < 4; i++) {
      final startAngle = (pi / 2) * i - arcLength / 2;
      canvas.drawArc(rect, startAngle, arcLength, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
