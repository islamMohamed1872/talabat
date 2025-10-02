import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 37,
    this.color = const Color(0xFFF65E00),
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      height: height,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(38),
      ),
      child: Text(
        text,
        style: textStyle ??
            const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: "madReg",
            ),
      ),
    );
  }
}
