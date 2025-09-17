import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/components/primary_button.dart';
import 'package:foodapp/modules/store/cubit/store_cubit.dart';
import 'package:foodapp/modules/store/cubit/store_states.dart';

import '../../components/const.dart';

class SandwichDetailsScreen extends StatelessWidget {
  const SandwichDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreCubit(),
      child: CustomScaffold(
        body: SafeArea(
          child: BlocBuilder<StoreCubit, StoreStates>(
            builder: (context, state) {
              final cubit = StoreCubit.get(context);

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Sandwich image with bounce-in animation
                          Center(
                            child: BounceInDown(
                              duration: const Duration(milliseconds: 600),
                              child: Image.asset(
                                "assets/images/sandwitch.png",
                                width: 200.w,
                                height: 210.h,
                              ),
                            ),
                          ),

                          /// Title + price row
                          FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            delay: const Duration(milliseconds: 300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text18Style(text: "ساندوتش ذا فاير بيرد"),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "120",
                                        style: TextStyle(
                                          fontFamily: "madReg",
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " ${"pound".tr()}",
                                        style: TextStyle(
                                          fontFamily: "madReg",
                                          fontSize: 14.sp,
                                          color: const Color(0xffA2A2A2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10.h),

                          /// Ingredients description
                          FadeIn(
                            duration: const Duration(milliseconds: 400),
                            delay: const Duration(milliseconds: 500),
                            child: text10Style(
                              text:
                              "${"fried_chicken_breast".tr()} ,${"jalapeno".tr()} ,${"lettuce".tr()} ,${"pickles".tr()} ,${"fire_sauce".tr()} ,${"cheddar_sauce".tr()} ,${"beef_bacon".tr()} ,${"tomato".tr()}",
                              color: const Color(0xff949494),
                            ),
                          ),

                          SizedBox(height: 25.h),

                          /// Options list
                          ...cubit.options.asMap().entries.map((entry) {
                            final index = entry.key;
                            final opt = entry.value;
                            return FadeInLeft(
                              duration: const Duration(milliseconds: 400),
                              delay: Duration(milliseconds: 200 * index),
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Radio<String>(
                                      value: opt["label"]!,
                                      groupValue: cubit.selectedSandwichOption,
                                      onChanged: (value) {
                                        cubit.changeSelectedSandwichOption(value!);
                                      },
                                      side: const BorderSide(width: 1),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      fillColor: WidgetStateProperty.all(Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: text12Style(text: opt['label']!.tr()),
                                  ),
                                  text10Style(
                                      text: opt["price"] ?? "",
                                      color: const Color(0xff949494))
                                ],
                              ),
                            );
                          }).toList(),

                          SizedBox(height: 25.h),

                          /// Ingredients with counters
                          ...cubit.ingredients.asMap().entries.map((entry) {
                            final index = entry.key;
                            final ingredient = entry.value;
                            return FadeInRight(
                              duration: const Duration(milliseconds: 400),
                              delay: Duration(milliseconds: 200 * index),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Row(
                                  children: [
                                    text12Style(text: ingredient['name']!.toString().tr()),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xffE2E2E2)),
                                        borderRadius: BorderRadius.circular(30.r),
                                      ),
                                      height: 27.h,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => cubit.increaseIngredient(ingredient['name']!),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                                              child: Icon(Icons.add, size: 16.sp),
                                            ),
                                          ),
                                          Container(width: 1, height: double.infinity, color: const Color(0xffE2E2E2)),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                                            child: text12Style(text: ingredient['count'].toString()),
                                          ),
                                          Container(width: 1, height: double.infinity, color: const Color(0xffE2E2E2)),
                                          InkWell(
                                            onTap: () => cubit.decreaseIngredient(ingredient['name']!),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                                              child: Icon(Icons.remove, size: 16.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),

                          SizedBox(height: 20.h),

                          /// Buttons row
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 600),
                            child: Row(
                              spacing: 12.w,
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: "add_to_cart".tr(),
                                    onPressed: () {},
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(mainColor)),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  height: 35.h,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () => cubit.increaseSelectedItem(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                                          child: Icon(Icons.add, size: 16.sp),
                                        ),
                                      ),
                                      Container(width: 1, height: double.infinity, color: Color(mainColor)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: text16Style(text: cubit.selectedItemCount.toString()),
                                      ),
                                      Container(width: 1, height: double.infinity, color: Color(mainColor)),
                                      InkWell(
                                        onTap: () => cubit.decreaseSelectedItem(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                                          child: Icon(Icons.remove, size: 16.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    /// Back button with fade
                    Positioned(
                      top: 30.h,
                      left: context.locale.languageCode == 'ar' ? 30.w : null,
                      right: context.locale.languageCode == 'en' ? 30.w : null,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(const EdgeInsets.all(7)),
                            minimumSize: WidgetStateProperty.all(Size(20.w, 20.w)),
                          ),
                          onPressed: () => Navigator.pop(context),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
