import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

final int mainColor = 0xffF75F00;

text18Style({required final String text,Color? color,String? fontFamily}) => Text(
  text,
  style: TextStyle(fontFamily:fontFamily?? "madMd", fontSize: 18.sp,color:color?? Colors.black),
);
text16Style({required final String text,Color? color,String? fontFamily}) => Text(
  text,
  style: TextStyle(fontFamily:fontFamily?? "madReg", fontSize: 16.sp,color:color?? Colors.black),
);
text14Style({required final String text,Color? color,String? fontFamily}) => Text(
  text,
  style: TextStyle(fontFamily:fontFamily?? "madMd", fontSize: 14.sp,color:color?? Colors.black),
);

text12Style({required final String text,Color? color,String? fontFamily,int? maxLines}) => Text(
  text,
  maxLines: maxLines,
  style: TextStyle(fontFamily:fontFamily?? "madReg", fontSize: 12.sp,color:color?? Colors.black),
);
text10Style({required final String text,Color? color,String? fontFamily,int? maxLines}) => Text(
  text,
  maxLines: maxLines,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontFamily:fontFamily?? "madReg", fontSize: 10.sp,color:color?? Colors.black),
);

void navigateTo(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}

/// Navigate and remove previous with animation
void navigateAndFinish(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide up transition
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}
showToastMessage({
  required String message,
  required Color color,
})=>Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0.sp
);