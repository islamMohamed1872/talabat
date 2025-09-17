import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/components/primary_button.dart';
import 'package:foodapp/modules/cart/cubit/cart_cubit.dart';
import 'package:foodapp/modules/cart/cubit/cart_states.dart';

import '../../components/const.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => CartCubit(),
          child: BlocBuilder<CartCubit, CartStates>(
            builder: (context, state) {
              final cubit = CartCubit.get(context);
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
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
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Row(
                          spacing: 25.w,
                          children: [
                            Image.asset(
                              "assets/images/sandwitch.png",
                              height: 100.h,
                              width: 100.w,
                            ),
                            Expanded(
                              child: Column(
                                spacing: 3.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text12Style(text: "ساندوتش ذا فاير بيرد"),
                                  text10Style(
                                    text:
                                        "${"fried_chicken_breast".tr()} ,${"jalapeno".tr()} ,${"lettuce".tr()} ,${"pickles".tr()} ,${"fire_sauce".tr()} ,${"cheddar_sauce".tr()} ,${"beef_bacon".tr()} ,${"tomato".tr()}",
                                    color: Color(0xff949494),
                                  ),
                                  Row(
                                    spacing: 5.w,
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
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '440 جنية ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontFamily: 'madMd',
                                          ),
                                        ),
                                        TextSpan(
                                          text: '520 جنية',
                                          style: TextStyle(
                                            color: const Color(0xFF848484),
                                            fontSize: 10.sp,
                                            fontFamily: 'madMd',
                                            decoration: TextDecoration
                                                .lineThrough, // ✅ correct
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20.h),
                        itemCount: 2,
                      ),
                      SizedBox(height: 12.h),
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
                          minLines: 1, // start with one line
                          maxLines: null, // grow automatically
                          decoration: InputDecoration(
                            border:
                                InputBorder.none, // removes default underline
                            hint: text10Style(
                              text: "comment_for_restaurant".tr(),
                              color: Color(0xffDEDEDE),
                            ), // your hint text
                            contentPadding:
                                EdgeInsets.zero, // keeps padding consistent
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      text12Style(text: "order_summary".tr()),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text10Style(text: "total_order".tr()),
                          text10Style(text: "594.00 ${"pound".tr()}"),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text10Style(text: "discount".tr()),
                          text10Style(text: "94.00 ${"pound".tr()}"),
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
                        color: Color(0xffE3E3E3),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text10Style(text: "final_price".tr()),
                          text10Style(text: "34.00 ${"pound".tr()}"),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        spacing: 20.w,
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: "add_meal".tr(),
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              color: Colors.white,
                              height: 37,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(38),
                                side: BorderSide(
                                  color: Color(mainColor)
                                )
                              ),
                              child: Text(
                                "pay_now".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(mainColor),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
