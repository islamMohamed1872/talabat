import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final ValueChanged? onChange;
  final bool? noIcon;
  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onSearch,
    this.onChange,
    this.noIcon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16.w, ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        spacing: 10,
        children: [
          if(noIcon!=true)
           GestureDetector(
            onTap: onSearch,
            child:  Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18.sp,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onChange,
              controller: controller,
              textAlign: TextAlign.right, // align placeholder for Arabic
              decoration: InputDecoration(
                hintText: "search_bar_hint".tr(),
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: "madReg",
                  color: Color(0xff6F6F6F),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
