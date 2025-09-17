import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/modules/store/sandwich_details_screen.dart';

import '../../components/const.dart';
import 'cubit/store_cubit.dart';
import 'cubit/store_states.dart';

class StoreDetailsScreen extends StatelessWidget {
  const StoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreCubit, StoreStates>(
      builder: (context, state) {
        final cubit = StoreCubit.get(context);
        return CustomScaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/resturant_banner.png",
                      width: double.infinity,
                        height: 170.h,
                        fit: BoxFit.fill,
                      ).animate()
                          .fadeIn(duration: 600.ms)
                          .scale(begin: Offset(1.1, 1.1), curve: Curves.easeOut),
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          spacing: 8.w,
                          children: [
                            Container(
                              height: 30.h,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: const Color(0xFFE1E1E1),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center(
                                child: text10Style(text: "main_menu".tr()),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: const Color(0xFFE1E1E1),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center(
                                child: text10Style(text: "special_offers".tr()),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: const Color(0xFFE1E1E1),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center(
                                child: text10Style(text: "meals".tr()),
                              ),
                            ),
                            Container(
                              height: 30.h,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: const Color(0xFFE1E1E1),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center(
                                child: text10Style(text: "sandwiches".tr()),
                              ),
                            ),
                          ],
                        ).animate()
                            .slideX(begin: -0.2, duration: 400.ms)
                            .fadeIn(),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 5 items per row
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 25.h,
                            childAspectRatio: 1, // adjust height vs width
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                navigateTo(context, SandwichDetailsScreen());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      index%2==0?
                                      "assets/images/sandwitch.png":
                                      "assets/images/sandwitch2.png",
                                      width: 100.w,
                                      height: 100.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 85.w,
                                    child: Column(
                                      crossAxisAlignment:  CrossAxisAlignment.start,
                                      children: [
                                        text12Style(text: index%2==0?
                                        "ساندوتش بيج زاك":
                                            "ساندوتش ذا رانشر",
                                            fontFamily: "madMd"),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                          TextSpan(
                                          text: "120",
                                            style: TextStyle(
                                                fontFamily:"madReg",
                                                fontSize: 12.sp,
                                                color: Colors.black
                                            ),
                                          ),
                                              TextSpan(
                                                text: "pound".tr(),
                                            style: TextStyle(
                                                fontFamily:"madReg",
                                                fontSize: 12.sp,
                                                color: Color(0xffA2A2A2)
                                            ),
                                              )
                                            ]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate(delay: (100 * index).ms) // stagger
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.2, curve: Curves.easeOut);
                          },
                        ),
                      ),

                    ],
                  ),
                  Positioned(
                    top: 70.h,
                    left: context.locale.languageCode == 'ar' ? 30.w : null,
                    right: context.locale.languageCode == 'en' ? 30.w : null,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.white,
                        ),
                        padding: WidgetStateProperty.all(EdgeInsets.all(7)), // smaller padding
                        minimumSize: WidgetStateProperty.all(Size(20.w, 20.w)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        context.locale.languageCode == 'ar'
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios_new,
                        color: Color( mainColor),
                        size: 17.w,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140.h,
                    right: context.locale.languageCode == 'ar' ? 30.w : null,
                    left: context.locale.languageCode == 'en' ? 30.w : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 78.w,
                          height: 78.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(image: AssetImage("assets/images/resturant_profile.png"),
                            fit: BoxFit.cover
                            )
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text14Style(text: "مطعم زاكس"),
                            text12Style(text: "فرايد تشيكن",color: Color(0xff787878))
                          ],
                        ),
                      ],
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
