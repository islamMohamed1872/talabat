import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/controllers/store/store_cubit.dart';
import '../../controllers/store/store_states.dart';
import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/primary_button.dart';

class SandwichDetailsScreen extends StatelessWidget {
  const SandwichDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: BlocConsumer<StoreCubit, StoreStates>(
          builder: (context, state) {
            final cubit = StoreCubit.get(context);

            if (state is GetSandwichDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cubit.sandwichDetails == null) {
              return const Center(child: Text("No sandwich data"));
            }

            final sandwich = cubit.sandwichDetails!;

            return SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Sandwich image
                        Center(
                          child: BounceInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Image.network(
                              sandwich.imageFullUrl ?? "",
                              width: 200.w,
                              height: 210.h,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => SizedBox(
                                width: 100.w,
                                height: 100.w,
                                child: Icon(
                                  Icons.image,
                                  size: 50.w,
                                ),
                              ),
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
                              text18Style(text: sandwich.name),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: sandwich.price.toString(),
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

                        /// Description
                          FadeIn(
                            duration: const Duration(milliseconds: 400),
                            delay: const Duration(milliseconds: 500),
                            child: text10Style(
                              text: sandwich.description,
                              color: const Color(0xff949494),
                            ),
                          ),

                        SizedBox(height: 25.h),

                        /// Variations (Options)
                        ...sandwich.variations.asMap().entries.map((entry) {
                          final index = entry.key;
                          final variation = entry.value;

                          return FadeInLeft(
                            duration: const Duration(milliseconds: 400),
                            delay: Duration(milliseconds: 200 * index),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.3,
                                  child: Radio<String>(
                                    value: variation.values.first.label,
                                    groupValue: cubit.selectedSandwichOption,
                                    onChanged: (value) {
                                      cubit.changeSelectedSandwichOption(value!);
                                    },
                                    side: const BorderSide(width: 1),
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    fillColor:
                                    WidgetStateProperty.all(Color(mainColor)),
                                  ),
                                ),
                                Expanded(
                                  child: text12Style(
                                    text: variation.values.first.label,
                                  ),
                                ),
                                text10Style(
                                  text: "${variation.values.first.optionPrice.toString()} ${"pound".tr()}",
                                  color: const Color(0xff949494),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        SizedBox(height: 25.h),

                        /// Add-ons (Ingredients)
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
                                  text12Style(text: ingredient['name']),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffE2E2E2)),
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    height: 27.h,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () => cubit.increaseIngredient(
                                              ingredient['name']),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            child: Icon(Icons.add, size: 16.sp),
                                          ),
                                        ),
                                        Container(
                                            width: 1,
                                            height: double.infinity,
                                            color: const Color(0xffE2E2E2)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: text12Style(
                                              text: ingredient['count']
                                                  .toString()),
                                        ),
                                        Container(
                                            width: 1,
                                            height: double.infinity,
                                            color: const Color(0xffE2E2E2)),
                                        InkWell(
                                          onTap: () => cubit.decreaseIngredient(
                                              ingredient['name']),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            child: Icon(Icons.remove,
                                                size: 16.sp),
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
                                  onPressed: () async {
                                    await cubit.addToCart(
                                      image: sandwich.imageFullUrl??"",
                                      productId: sandwich.id,
                                      name: sandwich.name,
                                      description: sandwich.description,
                                      price: sandwich.price.toDouble(),
                                      quantity: cubit.selectedItemCount,
                                      options: cubit.selectedSandwichOption ?? '',
                                      ingredients: cubit.ingredients,
                                    );

                                    // Confirmation
                                    showToastMessage(message: "added_to_cart".tr(), color: Color(mainColor));
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text("تمت إضافة ${sandwich.name} إلى السلة"),
                                    //     duration: const Duration(seconds: 2),
                                    //   ),
                                    // );
                                  },
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        child: Icon(Icons.add, size: 16.sp),
                                      ),
                                    ),
                                    Container(
                                        width: 1,
                                        height: double.infinity,
                                        color: Color(mainColor)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: text16Style(
                                          text: cubit.selectedItemCount
                                              .toString()),
                                    ),
                                    Container(
                                        width: 1,
                                        height: double.infinity,
                                        color: Color(mainColor)),
                                    InkWell(
                                      onTap: () => cubit.decreaseSelectedItem(),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
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

                  /// Back button
                  Positioned(
                    top: 30.h,
                    left: 30.w,
                    child: FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: 
                            Icon(
                              context.locale.languageCode == 'ar'
                                  ? Icons.arrow_forward_ios
                                  : Icons.arrow_back_ios_new,
                              color: Color(mainColor),
                              size: 17.w,
                            
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener:(context, state) {
            print(state);
          },
        ),
      ),
    );
  }
}

