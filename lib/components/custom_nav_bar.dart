import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/const.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": FontAwesomeIcons.house, "label": "home_page".tr()},
      {"icon": FontAwesomeIcons.store, "label": "المتجر"},
      {"icon": FontAwesomeIcons.magnifyingGlass, "label": "البحث"},
      {"icon": FontAwesomeIcons.user, "label": "الحساب"},
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // shadow color
            blurRadius: 6,                        // softness
            offset: const Offset(0, -5),          // negative Y = shadow from top
          ),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(mainColor).withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    items[index]["icon"] as IconData,
                    color: isSelected ? Color(mainColor) : Colors.black,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                if (isSelected)
                  Text(
                    items[index]["label"] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "madL",
                      color: Color(mainColor),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );

  }
}
