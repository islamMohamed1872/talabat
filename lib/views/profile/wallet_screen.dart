import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/controllers/profile/profile_cubit.dart';
import '../../controllers/profile/profile_states.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/profile_circle.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: SafeArea(
            child: BlocBuilder<ProfileCubit,ProfileStates>(
                builder: (context, state) {
                  final cubit = ProfileCubit.get(context);
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0,end: 20,top: 20),
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              // Profile circle
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: -30, end: 0),
                                duration: const Duration(milliseconds: 400),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, value),
                                    child: Opacity(
                                      opacity: 1 - (value.abs() / 30),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Center(child: ProfileCircle()),
                              ),

                              SizedBox(height: 15.h),

                              // Name
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                                child: text14Style(text: "محمود شحاتة"),
                              ),

                              SizedBox(height: 40.h),

                              // First row of stats
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
                                child: Row(
                                  spacing: 20.w,
                                  children: [
                                    _buildStatCard(context, "total".tr(),cubit.walletDetails==null?"0": cubit.walletDetails!.balance.toString(), "egyptian_pound".tr(),
                                        state: state,
                                        cubit: cubit,
                                        color: Color(mainColor).withValues(alpha: 0.1), textColor: Colors.black),
                                    _buildStatCard(context, "completed_orders".tr(),cubit.walletDetails==null?"0": cubit.walletDetails!.completedOrders.toString(), "egyptian_pound".tr(),
                                        state: state,
                                        cubit: cubit,
                                        color: Color(mainColor), textColor: Colors.white),
                                  ],
                                ),
                              ),

                              SizedBox(height: 30.h),

                              // Second row of stats
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 50, end: 0),
                                duration: const Duration(milliseconds: 600),
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
                                child: Row(
                                  spacing: 20.w,
                                  children: [
                                    _buildStatCard(context, "returned_orders".tr(),cubit.walletDetails==null?"0": cubit.walletDetails!.refundedOrders.toString(), "egyptian_pound".tr(),
                                        state: state,
                                        cubit: cubit,
                                        color: Color(mainColor), textColor: Colors.white),
                                    _buildStatCard(context, "cancelled_orders".tr(), cubit.walletDetails==null?"0":cubit.walletDetails!.cancelledOrders.toString(), "egyptian_pound".tr(),
                                        state: state,
                                        cubit: cubit,
                                        color: Color(mainColor), textColor: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 10.h,
                            left: 10.w,
                            child: TweenAnimationBuilder(
                              tween: Tween<double>(begin: -30, end: 0),
                              duration: const Duration(milliseconds: 400),
                              builder: (context, value, child) {
                                return Transform.translate(offset: Offset(value, 0), child: child);
                              },
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
                    ),
                  );
                },
            )
        ),
    );
  }
}

Widget _buildStatCard(BuildContext context, String title, String value, String unit,
    {required Color color, required Color textColor,required ProfileStates state, required ProfileCubit cubit}) {
  return Expanded(
    child: Skeletonizer(
      enabled: state is GetWalletDetailsLoadingState || cubit.walletDetails==null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 21),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Column(
          children: [
            text14Style(text: title, fontFamily: "madMd", color: textColor),
            text14Style(text: value, color: textColor),
            text14Style(text: unit, color: textColor),
          ],
        ),
      ),
    ),
  );
}

