import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'const.dart';
import 'package:foodapp/controllers/profile/profile_cubit.dart';

class ProfileCircle extends StatelessWidget {
  const ProfileCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CustomPaint(
          painter: _FourArcsPainter(),
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE9DD),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child:ProfileCubit.get(context).profileImage==null?
              Image.network(
                ProfileCubit.get(context).user.image,
                fit: BoxFit.cover, 
                width: 120.w,
                height: 120.w,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.person, size: 50, color: Colors.grey),
              ):
              Image.file(ProfileCubit.get(context).profileImage!,
              fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Camera button overlay
        GestureDetector(
          onTap: () {
             ProfileCubit.get(context).pickProfileImage();
          },
          child: CircleAvatar(
            radius: 15.r,
            backgroundColor: Color(mainColor),
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 20.r,
            ),
          ),
        ),
      ],
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
