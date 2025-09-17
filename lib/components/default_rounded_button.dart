import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final TextStyle? textStyle;
  final double height;
  final double borderRadius;

  const DefaultOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFF65E00),
    this.textStyle,
    this.height = 50,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: color
          )
        ),
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: color,
                fontFamily: "madReg",
              ),
        ),
      ),
    );
  }
}
