import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final double border;
  final bool enabled;
  final ValueChanged? onChnage;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onChnage,
    this.enabled = true,
    this.obscureText = false,
    this.border = 8,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChnage,
      obscureText: obscureText,
      style:  TextStyle(
        fontSize: 12.sp,
        fontFamily: "madReg",
        color: Colors.black,
      ),
      decoration: InputDecoration(
        label: Text(hintText,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: "madReg",
            color: Colors.black,),
        ),
        hintStyle:  TextStyle(
          fontSize: 12.sp,
          fontFamily: "madReg",
          color: Colors.black,),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(border),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey,),
          borderRadius: BorderRadius.circular(border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(border),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(border),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(border),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
