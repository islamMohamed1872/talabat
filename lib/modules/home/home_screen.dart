import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/const.dart';
import 'package:foodapp/components/custom_search_field.dart';
import 'package:foodapp/modules/cart/cart_screen.dart';
import 'package:foodapp/modules/home/best_seller_screen.dart';
import 'package:foodapp/modules/home/categories_screen.dart';
import 'package:foodapp/modules/home/cubit/home_cubit.dart';
import 'package:foodapp/modules/home/cubit/home_states.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 20.0,start: 20,end: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.locationDot,color: Color(mainColor),
                          size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          text14Style(text: "delivery_address".tr(),color: Color(mainColor)),
                          text14Style(text: "6 شارع ابو السنون الزيتون"),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                              onTap: () {
                  
                              },
                              child: Icon(Icons.keyboard_arrow_down_sharp)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, CartScreen()); 
                            },
                            child: CircleAvatar(
                              radius:16.w,
                              backgroundColor: Color(mainColor),
                              child: Image.asset("assets/images/cart.png",width: 22.w,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      CustomSearchBar(controller: cubit.searchController),
                      SizedBox(
                        height: 22.h,
                      ),
                      Stack(
                        alignment: AlignmentGeometry.bottomCenter,
                        children: [
                          CarouselSlider(
                            items: cubit.sliderItems,
                            options: CarouselOptions(
                              height: 120.h,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                cubit.changeSliderIndex(index);
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(cubit.sliderItems.length, (index) {
                                final isActive = cubit.currentSliderIndex == index;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  width: isActive ? 16.w : 8.w,
                                  height: 8.w,
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: isActive ? Colors.orange : Colors.white,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text14Style(text: "categories".tr()),
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, CategoriesScreen());
                            },
                            child: text14Style(text: "view_all".tr(),fontFamily: "madReg",color: Color(mainColor)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        height: 80.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: cubit.categories.isNotEmpty ? 5 : 0,
                          separatorBuilder: (context, index) => const SizedBox(width: 20),
                          itemBuilder: (context, index) {
                            final category = cubit.categories[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              delay: Duration(milliseconds: 100 * index), // nice stagger
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                curve: Curves.easeOutCubic,
                                child: FadeInAnimation(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 55.w,
                                        height: 55.w,
                                        decoration: BoxDecoration(
                                          color: Color(cubit.colors[index % 9]).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Image.network(
                                          category.imageFullUrl!,
                                          width: 28.w,
                                          height: 28.w,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      text12Style(text: category.name),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text14Style(text: "best_selling_offers".tr()),
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, BestSellerScreen());
                            },
                            child: text14Style(text: "view_all".tr(),fontFamily: "madReg",color: Color(mainColor)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        height: 100.h,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>  AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              delay: Duration(milliseconds: 100 * index),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                curve: Curves.easeOutCubic,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                  
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/food.png",
                                          width: 85.w,
                                          height: 50.w,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "chicken_meal_with_potatoes".tr(),
                                          style: TextStyle(
                                              fontFamily:"madReg",
                                              fontSize: 10.sp,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "grills".tr(),
                                          style: TextStyle(
                                              fontFamily:"madReg",
                                              fontSize: 9.sp,
                                              color: Color(0xff909090)),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "5.0",
                                              style: TextStyle(
                                                  fontFamily:"madReg",
                                                  fontSize: 9.sp,
                                                  color: Color(0xffFFCF36)),
                                            ),
                                            Icon(Icons.star_rounded,color: Color(0xffFFCF36),
                                                size: 15.w,),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Text(
                                              "120 ${"pound".tr()}",
                                              style: TextStyle(
                                                  fontFamily:"madReg",
                                                  fontSize: 9.sp,
                                              ),
                                            ),
                                    
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              width: 40,
                            ),
                            itemCount: 5),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text14Style(text: "daily_offers".tr()),
                          GestureDetector(
                            onTap: () {
                            },
                            child: text14Style(text: "view_all".tr(),fontFamily: "madReg",color: Color(mainColor)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 60.h,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/food2.png",
                                  width: 85.w,
                                  height: 60.w,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 6),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "chicken_meal_with_potatoes".tr(),
                                      style: TextStyle(
                                          fontFamily:"madReg",
                                          fontSize: 10.sp,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "150",
                                          style: TextStyle(
                                              fontFamily:"madReg",
                                              fontSize: 9.sp,
                                              decoration: TextDecoration.lineThrough, // adds the line
                                              decorationColor: Colors.red,            // optional: same as text color
                                              decorationThickness: 2,
                                              color: Colors.red),
                                        ),
                                        AnimatedSwitcher(
                                          duration: Duration(milliseconds: 400),
                                          child: Text(
                                            "120 ${"pound".tr()}",
                                            style: TextStyle(
                                              fontFamily:"madReg",
                                              fontSize: 9.sp,
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                            itemCount: 5),
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
