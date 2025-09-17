import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/const.dart';


class DefaultAppBar extends StatelessWidget {
  final String title;
  final BuildContext context;
  final String lang;

  const DefaultAppBar({
    super.key,
    required this.title,
    required this.context,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: "madMd",
              color: Color(mainColor)
            ),
          ),
        ),
        Align(
          alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Color(mainColor).withValues(alpha: 0.2),
              ),
            ),
            onPressed: () => Navigator.pop(this.context),
            icon: Icon(
              lang == 'ar'
                  ? FontAwesomeIcons.arrowLeftLong
                  : FontAwesomeIcons.arrowRightLong,
              color: Color( mainColor),
              size: 15,
            ),
          ),
        ),
      ],
    );
  }



}
