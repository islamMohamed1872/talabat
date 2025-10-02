import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/controllers/cart/cart_cubit.dart';
import 'package:foodapp/controllers/cart/cart_states.dart';
import 'package:foodapp/views/cart/edit_sandwich_details_screen.dart';
import 'package:foodapp/controllers/home/home_cubit.dart';
import 'package:foodapp/views/home/screens_holder.dart';
import 'package:lottie/lottie.dart';

import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/primary_button.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartStates>(
          builder: (context, state) {
            final cubit = CartCubit.get(context);

            final total = cubit.items.fold<double>(
              0.0,
                  (sum, item) =>
              sum +
                  ((double.parse(item['totalPrice']) as num?)?.toDouble() ?? 0)
            );

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ConditionalBuilder(condition: cubit.items.isNotEmpty,
                  builder: (context) => Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                IconButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    WidgetStateProperty.all(Colors.white),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.all(7),
                                    ),
                                    minimumSize: WidgetStateProperty.all(
                                      Size(20.w, 20.w),
                                    ),
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
                              ],
                            ),
                            SizedBox(height: 30.h),

                            // ✅ Dynamic cart items
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = cubit.items[index];
                                return Row(
                                  spacing: 25.w,
                                  children: [
                                    // product image
                                    item['image'] != null
                                        ? Image.network(
                                      item['image'],
                                      height: 100.h,
                                      width: 100.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => SizedBox(
                                        width: 100.w,
                                        height: 100.h,
                                        child: Icon(Icons.image,
                                          size: 40.w,
                                        ),
                                      ),
                                    )
                                        : Image.asset(
                                      "assets/images/sandwitch.png",
                                      height: 100.h,
                                      width: 100.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        spacing: 3.h,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          text12Style(
                                              text: item['name'] ?? "No name"),
                                          text10Style(
                                              text: item['totalPrice'].toString(),
                                              color: const Color(0xff949494),
                                              maxLines: 2
                                          ),

                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cubit.changeSelectedItem(index);
                                                  // print(cubit.items[index]);
                                                  cubit.changeSelectedItemId(item['id']);
                                                  cubit.getSandwichDetails(int.parse(item['productId']));
                                                  navigateTo(context, EditSandwichDetailsScreen());
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/edit.png",
                                                      width: 20.w,
                                                      color: Color(mainColor),
                                                    ),
                                                    text10Style(
                                                      text: "edit".tr(),
                                                      color: Color(mainColor),
                                                      fontFamily: "madMd",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () => cubit
                                                    .removeItem(item['id'] as int,context),
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),

                                          Text(
                                            "${item['price']} ${"pound".tr()} × ${item['quantity']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontFamily: 'madMd',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20.h),
                              itemCount: cubit.items.length,
                            ),

                            SizedBox(height: 12.h),

                            CustomTextFormField(controller: cubit.addressController, hintText: "delivery_address".tr(),onChnage: (value) {
                              cubit.addressChanged =true;
                            },
                            ),

                            SizedBox(height: 15.h),
                            text10Style(
                              text: "additional_comment_optional".tr(),
                              fontFamily: "madMd",
                            ),
                            SizedBox(height: 14.h),
                            Container(
                              width: double.infinity,
                              height: 71,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 0.60,
                                    color: Color(0xFFDDDDDD),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: TextFormField(
                                controller: cubit.noteController,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hint: text10Style(
                                    text: "comment_for_restaurant".tr(),
                                    color: const Color(0xffDEDEDE),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),
                            text12Style(text: "order_summary".tr()),
                            SizedBox(height: 15.h),

                            // ✅ Totals section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text10Style(text: "total_order".tr()),
                                text10Style(text: "$total ${"pound".tr()}"),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text10Style(text: "discount".tr()),
                                text10Style(text: "0 ${"pound".tr()}"),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text10Style(text: "delivery_tax".tr()),
                                text10Style(text: "24.00 ${"pound".tr()}"),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text10Style(text: "added_value_tax".tr()),
                                text10Style(text: "34.00 ${"pound".tr()}"),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: const Color(0xffE3E3E3),
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text10Style(text: "final_price".tr()),
                                text10Style(
                                  text: "${total + 24 + 34} ${"pound".tr()}",
                                ),
                              ],
                            ),

                            SizedBox(height: 30.h),
                            Row(
                              spacing: 20.w,
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: "add_meal".tr(),
                                    onPressed: () {
                                      HomeCubit.get(context).changeCurrentIndex(1);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {
                                      if(state is !CheckOutLoadingState){
                                        cubit.checkOut(context);
                                      }
                                    },
                                    color:state is !CheckOutLoadingState ? Colors.white: Colors.grey,
                                    height: 37,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(38),
                                      side: BorderSide(color:state is !CheckOutLoadingState ? Color(mainColor):Colors.grey),
                                    ),
                                    child: Text(
                                      "pay_now".tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:state is !CheckOutLoadingState ? Color(mainColor):Colors.white,
                                        fontFamily: "madReg",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (cubit.orderPlaced)
                        SizedBox(
                          height: 200.h,
                          width: double.infinity,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: -200, end: MediaQuery.of(context).size.width),
                            duration: const Duration(seconds: 3),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(value, 0),
                                child: Lottie.asset(
                                  "assets/lottie/delivery_riding.json",
                                  width: 150.w,
                                  repeat: true,
                                ),
                              );
                            },
                          ),
                        ),

                    ],
                  ),
                  fallback: (context) => Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            style: ButtonStyle(
                              backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.all(7),
                              ),
                              minimumSize: WidgetStateProperty.all(
                                Size(20.w, 20.w),
                              ),
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
                        ],
                      ),
                      SizedBox(
                        height: 300.h,
                        width: double.infinity,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 200, end: 0),
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(value, 0),
                              child: Lottie.asset(
                                "assets/lottie/no_orders.json",
                                width: 150.w,
                                repeat: true,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TweenAnimationBuilder<Offset>(
                          tween: Tween(begin: const Offset(0, 1), end: Offset.zero),
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: value * 50, // pushes down then up
                              child: child,
                            );
                          },
                          child: PrimaryButton(
                            text: "add_meal".tr(),
                            onPressed: () {
                              HomeCubit.get(context).changeCurrentIndex(1);
                             Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                    ],
                  )),
            );
          },
          listener: (context, state) {
            print(state);
            if (state is CheckOutSuccessState) {
              Future.delayed(const Duration(seconds: 3), () {
                CartCubit.get(context).resetOrderPlaced();
              });
            }
          },
        ),
      ),
    );
  }
}
