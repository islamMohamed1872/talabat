import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/const.dart';
import '../../components/custom_scaffold.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_states.dart';

class TotalOrdersScreen extends StatelessWidget {
  const TotalOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            final cubit = ProfileCubit.get(context);
            return Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
                end: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 65.h),
                      child: Column(
                        spacing: 20.h,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 50, end: 0),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, value),
                                child: Opacity(
                                  opacity: 1 - (value / 50),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildOrderCard(context),
                          ),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 50, end: 0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, value),
                                child: Opacity(
                                  opacity: 1 - (value / 50),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildOrderCard(context, showTrack: false),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: -30, end: 0),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(value, 0),
                            child: child,
                          );
                        },
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(const EdgeInsets.all(7)),
                            minimumSize: WidgetStateProperty.all(Size(20.w, 20.w)),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            context.locale.languageCode == 'ar'
                                ? Icons.arrow_forward_ios
                                : Icons.arrow_back_ios_new,
                            color: Color(mainColor),
                            size: 17.w,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, {bool showTrack = true}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(horizontal: 21, vertical: 11),
          decoration: ShapeDecoration(
            color: Color(mainColor).withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Color(mainColor),
              ),
              borderRadius: BorderRadius.circular(51),
            ),
          ),
          child: Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: text12Style(
                  text: "${"order_sent".tr()}: 04/08/2025 09:13 صباحا",
                  fontFamily: "madMd",
                ),
              ),
              if (showTrack)
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: Center(
                    child: text10Style(
                      text: "track_order".tr(),
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            text12Style(text: "order_number".tr(), fontFamily: "madMd"),
            text12Style(text: ": 232-764340"),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            text12Style(text: "delivery_time".tr(), fontFamily: "madMd"),
            text12Style(text: ": ${"not_yet_determined".tr()}"),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            text12Style(text: "address".tr(), fontFamily: "madMd"),
            text12Style(text: ": 3 شارع جسر السويس القاهره "),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          spacing: 10.w,
          children: [
            Image.asset(
              "assets/images/meal.png",
              width: 70.w,
              height: 55.h,
            ),
            Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text10Style(text: "وجبة فراخ بالبطاطس"),
                text10Style(text: "120 ${"pound".tr()}"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
