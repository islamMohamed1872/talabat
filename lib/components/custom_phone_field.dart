import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:foodapp/components/const.dart';
import 'dart:ui' as ui;

import 'package:foodapp/modules/auth/register/cubit/register_cubit.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator; // add validator
  final double border;
  const PhoneNumberField({super.key, required this.controller, this.validator,this.border = 10});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            validator: validator, // apply validator here
            decoration: InputDecoration(
              hintText: "phone_number".tr(),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
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
              suffixIcon: Directionality(
                textDirection:context.locale.languageCode=="ar"?
                ui.TextDirection.ltr:
                ui.TextDirection.rtl,
                child: CountryCodePicker(
                  onChanged: (code) {
                    RegisterCubit.get(context).countryCode = code.dialCode!;
                    print(code.dialCode);
                  },
                  initialSelection: 'EG', // Egypt
                  favorite: ['+20', 'EG'],
                  showFlag: true,
                  padding: EdgeInsets.zero,
                  textStyle: TextStyle(fontSize: 14.sp,
                      color: Color(mainColor),
                      fontFamily: "madReg"
                  ),
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 5),
                  flagWidth: 25,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
