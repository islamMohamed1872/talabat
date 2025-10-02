import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/models/orders_model.dart';
import '../../controllers/profile/profile_cubit.dart';
import '../../controllers/profile/profile_states.dart';
import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';

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
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 65.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                        itemBuilder: (context, index) => TweenAnimationBuilder(
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
                          child: _buildOrderCard(
                              context,
                              showTrack: cubit.orders[index].orderStatus=="out_for_delivery",
                              sentTime: cubit.formatDateTime(cubit.orders[index].orderTime,context),
                              orderNumber: cubit.orders[index].id.toString(),
                              deliveryTime: cubit.formatDateTime(cubit.orders[index].deliveryTime,context),
                              address: cubit.orders[index].deliveryAddress==null?"":cubit.orders[index].deliveryAddress!.address,
                              items: cubit.orders[index].items,),
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 15.h,
                        ), itemCount: cubit.orders.length),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, {
        bool showTrack = true,
        required String sentTime,
        required String orderNumber,
        required String? deliveryTime,
        required String address,
        required List<OrderItem> items,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====== top header (order sent + track) ======
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 11),
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
                  text: "${"order_sent".tr()} : $sentTime",
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

        // ====== order number ======
        Row(
          children: [
            text12Style(text: "order_number".tr(), fontFamily: "madMd"),
            text12Style(text: ": $orderNumber"),
          ],
        ),
        SizedBox(height: 10.h),

        // ====== delivery time ======
        Row(
          children: [
            text12Style(text: "delivery_time".tr(), fontFamily: "madMd"),
            text12Style(text: ": ${deliveryTime ?? "not_yet_determined".tr()}"),
          ],
        ),
        SizedBox(height: 10.h),

        // ====== address ======
        Row(
          children: [
            text12Style(text: "address".tr(), fontFamily: "madMd"),
            Expanded(child:
            text12Style(text: ": $address ",maxLines: 1),)
          ],
        ),

        SizedBox(height: 20.h),

        // ====== loop through items ======
        Column(
          children: items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                spacing: 10.w,
                children: [
                  // item image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.image ?? "", // fallback empty string
                      width: 70.w,
                      height: 55.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 70.w,
                            height: 55.h,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.fastfood, size: 20),
                          ),
                    ),
                  ),

                  // item details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5.h,
                    children: [
                      text10Style(text: item.name),
                      text10Style(
                        text: "${item.price} ${"pound".tr()}",
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}
