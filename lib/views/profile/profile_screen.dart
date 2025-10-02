import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/controllers/profile/profile_cubit.dart';
import '../../controllers/profile/profile_states.dart';
import 'package:foodapp/views/profile/personal_info_screen.dart';
import 'package:foodapp/views/profile/total_orders_screen.dart';
import 'package:foodapp/views/profile/wallet_screen.dart';

import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/profile_circle.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            final cubit = ProfileCubit.get(context);

            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Profile image with bounce animation
                    Center(
                      child: BounceInDown(
                        duration: const Duration(milliseconds: 600),
                        child: ProfileCircle(),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    /// Username
                    FadeIn(
                      delay: const Duration(milliseconds: 300),
                      child: text14Style(text: "${cubit.user.firstName} ${cubit.user.lastName}"),
                    ),
                    SizedBox(height: 40.h),

                    /// Personal Info Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 200),
                      child: _buildOptionCard(
                        context,
                        icon: FontAwesomeIcons.user,
                        text: "personal_information".tr(),
                        onTap: () => navigateTo(context, const PersonalInfoScreen()),
                        isRtl: context.locale.languageCode == "ar",
                      ),
                    ),
                    SizedBox(height: 15.h),

                    /// Orders Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 400),
                      child: _buildOptionCard(
                        context,
                        icon: FontAwesomeIcons.receipt,
                        text: "total_orders".tr(),
                        onTap: () {
                          cubit.getOrders();
                          navigateTo(context, const TotalOrdersScreen());
                        },
                        isRtl: context.locale.languageCode == "ar",
                      ),
                    ),
                    SizedBox(height: 15.h),

                    /// Wallet Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 600),
                      child: _buildOptionCard(
                        context,
                        icon: FontAwesomeIcons.wallet,
                        text: "wallet".tr(),
                        onTap: () {
                          cubit.getWalletDetails();
                          navigateTo(context, const WalletScreen());
                        },
                        isRtl: context.locale.languageCode == "ar",
                      ),
                    ),
                    SizedBox(height: 15.h),

                    /// Language Dropdown
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 800),
                      child: _buildDropdownCard(
                        context,
                        icon: FontAwesomeIcons.language,
                        value: cubit.selectedLanguage,
                        items: cubit.languages,
                        onChanged: (value) async {
                          if (value != null) {
                            cubit.changeLanguage(value);
                            if (value == "ar") {
                              await context.setLocale(const Locale("ar"));
                            } else {
                              await context.setLocale(const Locale("en"));
                            }
                          }
                        },
                        displayBuilder: (lang) => lang == "ar" ? "العربية" : "English",
                      ),
                    ),
                    SizedBox(height: 15.h),

                    /// Country Dropdown
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 1000),
                      child: _buildDropdownCard(
                        context,
                        icon: FontAwesomeIcons.earthAmericas,
                        value: cubit.selectedCountry,
                        items: cubit.countries,
                        onChanged: (value) {
                          if (value != null) cubit.changeCountry(value);
                        },
                        displayBuilder: (country) => country,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    /// Logout Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 1200),
                      child: Container(
                        width: double.infinity,
                        height: 47.h,
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        decoration: ShapeDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text12Style(text: "logout".tr(), fontFamily: "madMd"),
                            Image.asset("assets/images/logout.png", width: 25.w),
                          ],
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

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
        required String text,
        required VoidCallback onTap,
        required bool isRtl}) {
    return Container(
      width: double.infinity,
      height: 47.h,
      padding: const EdgeInsets.symmetric(horizontal: 19),
      decoration: ShapeDecoration(
        color: Color(mainColor).withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(mainColor)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 10.w),
          text12Style(text: text, fontFamily: "madMd"),
          const Spacer(),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              isRtl ? FontAwesomeIcons.arrowLeftLong : FontAwesomeIcons.arrowRightLong,
              size: 17.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard(BuildContext context,
      {required IconData icon,
        required String value,
        required List<String> items,
        required ValueChanged<String?> onChanged,
        required String Function(String) displayBuilder}) {
    return Container(
      width: double.infinity,
      height: 47.h,
      padding: const EdgeInsets.symmetric(horizontal: 19),
      decoration: ShapeDecoration(
        color: Color(mainColor).withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(mainColor)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: items
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    displayBuilder(item),
                    style: const TextStyle(fontFamily: "madMd", fontSize: 14),
                  ),
                ))
                    .toList(),
                onChanged: onChanged,
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
