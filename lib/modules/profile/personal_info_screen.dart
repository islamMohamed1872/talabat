import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/custom_textformfield.dart';
import 'package:foodapp/components/default_button.dart';
import 'package:foodapp/components/default_rounded_button.dart';
import 'package:foodapp/modules/profile/password_screen.dart';

import '../../components/const.dart';
import '../../components/custom_scaffold.dart';
import '../../components/profile_circle.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_states.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

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
                    Column(
                      children: [
                        // Profile picture animation
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          builder: (context, value, child) => Transform.scale(
                            scale: value,
                            child: Opacity(opacity: value, child: child),
                          ),
                          child: Center(child: ProfileCircle()),
                        ),

                        SizedBox(height: 15.h),

                        // Name fade in
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOut,
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 15),
                              child: child,
                            ),
                          ),
                          child: text14Style(text: "محمود شحاتة"),
                        ),

                        SizedBox(height: 40.h),

                        // TextFields + Buttons with staggered fade-in
                        ...[
                          CustomTextFormField(
                            controller: cubit.nameController,
                            hintText: "name".tr(),
                            border: 30,
                          ),
                          SizedBox(height: 35.h),
                          CustomTextFormField(
                            controller: cubit.emailController,
                            hintText: "email".tr(),
                            border: 30,
                          ),
                          SizedBox(height: 35.h),
                          CustomTextFormField(
                            controller: cubit.phoneController,
                            hintText: "phone_number".tr(),
                            border: 30,
                          ),
                          SizedBox(height: 35.h),
                          DefaultButton(
                            text: "update_information".tr(),
                            onPressed: () {},
                            borderRadius: 30,
                            height: 45.h,
                          ),
                          SizedBox(height: 20.h),
                          DefaultOutlinedButton(
                            text: "update_password".tr(),
                            onPressed: () {
                              navigateTo(context, PasswordScreen());
                            },
                            borderRadius: 30,
                            height: 45.h,
                          ),
                        ]
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final widget = entry.value;
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 500 + (index * 150)),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 20),
                                child: child,
                              ),
                            ),
                            child: widget,
                          );
                        }).toList(),
                      ],
                    ),

                    // Back button animation
                    Positioned(
                      top: 20.h,
                      left: 10.w,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: -1, end: 0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, child) => Transform.translate(
                          offset: Offset(value * 50, 0),
                          child: child,
                        ),
                        child: IconButton(
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
}
