import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/controllers/store/store_cubit.dart';
import 'package:lottie/lottie.dart';
import '../../config/api_const.dart';
import '../../controllers/search/search_states.dart';
import '../store/sandwich_details_screen.dart';
import '../store/store_details_screen.dart';
import '../../controllers/search/search_cubit.dart';
import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_search_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          final cubit = SearchCubit.get(context);
          return CustomScaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    CustomSearchBar(
                      controller: cubit.searchController,
                      onChange: (value) {
                        cubit.getSearchResults();
                      },
                    ),
                    ConditionalBuilder(condition: cubit.searchedFood.isNotEmpty||cubit.searchedRestaurant.isNotEmpty&&cubit.searchController.text.isNotEmpty,
                        builder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 22.h),
                            text14Style(text: "all_restaurants".tr()),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 110.h,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
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
                                        print(cubit.searchedRestaurant[index].id);
                                        StoreCubit.get(context).getStoreDetails(cubit.searchedRestaurant[index].id);
                                        navigateTo(context, StoreDetailsScreen());
                                      },
                                      child: RestaurantItemCard(
                                        restaurantName: cubit.searchedRestaurant[index].name,
                                        rating: 0,
                                        deliveryTime: "",
                                        imagePath: cubit.searchedRestaurant[index].logo,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(width: 15.w),
                                itemCount: cubit.searchedRestaurant.length,
                              ),
                            ),
                            SizedBox(height: 22.h),
                            text14Style(text: "all_food".tr()),
                            SizedBox(height: 10.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 25.h,
                                childAspectRatio: 1,
                              ),
                              itemCount: cubit.searchedFood.length,
                              itemBuilder: (context, index) {
                                final item = cubit.searchedFood[index];

                                return GestureDetector(
                                  onTap: () {
                                    StoreCubit.get(context).getSandwichDetails(cubit.searchedFood[index].id);
                                    navigateTo(context, SandwichDetailsScreen());
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.network(
                                          item.imageFullUrl,
                                          width: 100.w,
                                          height: 100.w,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image_not_supported,
                                              size: 28.w,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      text12Style(text: item.name,
                                fontFamily: "madMd"),
                                    ],
                                  ),
                                )
                                    .animate(delay: (100 * index).ms) // stagger
                                    .fadeIn(duration: 400.ms)
                                    .slideY(begin: 0.2, curve: Curves.easeOut);
                              },
                            ),
                          ],
                        ), fallback: (context) => Expanded(
                          child: LottieBuilder.asset("assets/lottie/search.json"),
                        )
                      ,)

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RestaurantItemCard extends StatelessWidget {
  final String restaurantName;
  final double rating;
  final String deliveryTime;
  final String imagePath;

  const RestaurantItemCard({
    super.key,
    required this.restaurantName,
    required this.rating,
    required this.deliveryTime,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              "$imageBaseUrl$imagePath",
              // height: 50.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          text12Style(
            text: restaurantName,
            fontFamily: "madMd",
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
