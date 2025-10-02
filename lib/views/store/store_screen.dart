import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/controllers/home/home_cubit.dart';
import 'package:foodapp/controllers/store/store_cubit.dart';
import '../../config/api_const.dart';
import '../../controllers/store/store_states.dart';
import 'package:foodapp/views/store/store_details_screen.dart';

import '../widgets/const.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreCubit, StoreStates>(
      builder: (context, state) {
        final cubit = StoreCubit.get(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text14Style(text: "all_restaurants".tr()),
                SizedBox(height: 22.h),

                // Categories horizontal list
                SizedBox(
                  height: 80.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Container(
                          width: 43.w,
                          height: 43.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF1F1F1),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(7),
                          child: (HomeCubit.get(context).categories[index].imageFullUrl != null && HomeCubit.get(context).categories[index].imageFullUrl!.isNotEmpty)
                              ? Image.network(
                            HomeCubit.get(context).categories[index].imageFullUrl!,
                            width: 28.w,
                            height: 28.w,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                size: 28.w,
                                color: Colors.grey,
                              );
                            },
                          )
                              : Icon(
                            Icons.image,
                            size: 28.w,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        text12Style(text: HomeCubit.get(context).categories[index].name),
                      ],
                    ),
                    separatorBuilder: (context, index) => SizedBox(width: 20),
                    itemCount: HomeCubit.get(context).categories.length,
                  ),
                ),

                SizedBox(height: 20.h),

                // Filter and Sort buttons row
               SizedBox(
                  height: 35.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          cubit.filterRestaurants(RestaurantFilter.deliveryTime);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: cubit.selectedFilter == RestaurantFilter.deliveryTime
                                ? Color(mainColor)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: const Color(0xffE1E1E1)),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/filter.png",
                                width: 20.w,
                                color: cubit.selectedFilter == RestaurantFilter.deliveryTime
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              SizedBox(width: 5.w),
                              text10Style(
                                text: "sort_by_time".tr(),
                                color: cubit.selectedFilter == RestaurantFilter.deliveryTime
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Sort button
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 12.w),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(26),
                      //     border: Border.all(color: const Color(0xffE1E1E1)),
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton<String>(
                      //       value: cubit.selectedSortOption, // Current selected option
                      //       icon: Icon(
                      //         Icons.keyboard_arrow_down,
                      //         size: 16.sp,
                      //         color: Colors.black,
                      //       ),
                      //       dropdownColor: Colors.white,
                      //       items: [
                      //         DropdownMenuItem(
                      //           value: "rating",
                      //           child: Row(
                      //             children: [
                      //               Image.asset("assets/images/filter.png", width: 20.w),
                      //               SizedBox(width: 5.w),
                      //               text10Style(text: "sort_by_rating".tr()),
                      //             ],
                      //           ),
                      //         ),
                      //         DropdownMenuItem(
                      //           value: "deliveryTime",
                      //           child: Row(
                      //             children: [
                      //               Image.asset("assets/images/filter.png", width: 20.w),
                      //               SizedBox(width: 5.w),
                      //               text10Style(text: "sort_by_time".tr()),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //       onChanged: (value) {
                      //         if (value != null) {
                      //           cubit.sortRestaurants(value);
                      //           cubit.selectedSortOption = value; // Update local state
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: 10.w),
                      // Connect to restaurant button
                      GestureDetector(
                        onTap: () {
                          cubit.filterRestaurants(RestaurantFilter.pickupOnly);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: cubit.selectedFilter == RestaurantFilter.pickupOnly
                                ? Color(mainColor)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: const Color(0xffE1E1E1)),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/shipping.png",
                                width: 20.w,
                                color: cubit.selectedFilter == RestaurantFilter.pickupOnly
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              SizedBox(width: 5.w),
                              text10Style(
                                text: "pick_up".tr(),
                                color: cubit.selectedFilter == RestaurantFilter.pickupOnly
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),

                      // Delivery from restaurant button
                      GestureDetector(
                        onTap: () {
                          cubit.filterRestaurants(RestaurantFilter.freeDelivery);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: cubit.selectedFilter == RestaurantFilter.freeDelivery
                                ? Color(mainColor)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: const Color(0xffE1E1E1)),
                          ),
                          child: Center(
                            child: text10Style(
                              text: "free_delivery".tr(),
                              color: cubit.selectedFilter == RestaurantFilter.freeDelivery
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),



                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Restaurant list
                ConditionalBuilder(
                    condition: state is !GetAllRestaurantsLoadingState,
                    builder: (context)=>Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 500 + (index * 100)), // stagger
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 30 * (1 - value)), // slide up
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: GestureDetector(
                              onTap: (){
                                print(cubit.filteredRestaurants[index].id);
                                cubit.getStoreDetails(cubit.filteredRestaurants[index].id);
                                navigateTo(context, StoreDetailsScreen());
                              },
                              child: RestaurantItem(
                                restaurantName: cubit.filteredRestaurants[index].name!,
                                rating: cubit.filteredRestaurants[index].avgRating,
                                deliveryTime: cubit.filteredRestaurants[index].deliveryTime!,
                                imagePath: cubit.filteredRestaurants[index].logo!,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(height: 15.h),
                        itemCount: cubit.filteredRestaurants.length,
                      ),
                    ),
                    fallback: (context) => Center(child: CircularProgressIndicator(
                      color: Color(mainColor),
                    )))

              ],
            ),
          ),
        );
      },
    );
  }
}

class RestaurantItem extends StatelessWidget {
  final String restaurantName;
  final double rating;
  final String deliveryTime;
  final String imagePath;

  const RestaurantItem({
    super.key,
    required this.restaurantName,
    required this.rating,
    required this.deliveryTime,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Restaurant image
          Container(
            width: 120.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage("$imageBaseUrl$imagePath"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 15.w),

          // Restaurant details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant name
                text12Style(
                  text: restaurantName,
                  fontFamily: "madMd"
                ),
                SizedBox(height: 8.h),

                ///will be available in later releases
                // Rating and delivery time row
                // Row(
                //   children: [
                //     // Rating
                //     Row(
                //       children: [
                //         Icon(
                //           Icons.star_rounded,
                //           color: Colors.amber,
                //           size: 16.sp,
                //         ),
                //         SizedBox(width: 4.w),
                //         text12Style(
                //           text: "(310)",
                //           color: Colors.grey[400],
                //         ),
                //         text12Style(
                //           text: rating.toString(),
                //           color: Colors.black,
                //         ),
                //
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 5.h,
                // ),
                // Delivery time
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: Colors.black,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    text12Style(
                      text: deliveryTime,
                    ),
                    SizedBox(width: 4.w),
                    text12Style(
                      text: "minute".tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

