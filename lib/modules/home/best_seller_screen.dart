import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/components/default_appbar.dart';

import '../../components/const.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_states.dart';

class BestSellerScreen extends StatelessWidget {
  const BestSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return CustomScaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                spacing: 30.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DefaultAppBar(
                      title: "best_selling_offers".tr(),
                      context: context,
                      lang: context.locale.languageCode),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 5 items per row
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 25.h,
                        childAspectRatio: 1, // adjust height vs width
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 500 + (index * 100)), // staggered by index
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 30 * (1 - value)), // slide up
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/images/food.png",
                                  width: 85.w,
                                  height: 50.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 85.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "chicken_meal_with_potatoes".tr(),
                                      style: TextStyle(
                                        fontFamily: "madReg",
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "grills".tr(),
                                      style: TextStyle(
                                        fontFamily: "madReg",
                                        fontSize: 9.sp,
                                        color: Color(0xff909090),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "5.0",
                                          style: TextStyle(
                                            fontFamily: "madReg",
                                            fontSize: 9.sp,
                                            color: Color(0xffFFCF36),
                                          ),
                                        ),
                                        Icon(
                                          Icons.star_rounded,
                                          color: Color(0xffFFCF36),
                                          size: 15.w,
                                        ),
                                        SizedBox(width: 20.w),
                                        Text(
                                          "120 ${"pound".tr()}",
                                          style: TextStyle(
                                            fontFamily: "madReg",
                                            fontSize: 9.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // your action here
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 23.h),
                                  padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 4),
                                  backgroundColor: Color(mainColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  elevation: 0,
                                ),
                                child: text12Style(text: "add_to_cart".tr(), color: Colors.white),
                              )
                            ],
                          ),
                        );
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
