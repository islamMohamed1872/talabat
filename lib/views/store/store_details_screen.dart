import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/views/store/sandwich_details_screen.dart';
import '../../controllers/store/store_states.dart';
import '../../controllers/store/store_cubit.dart';
import '../widgets/const.dart';
import '../widgets/custom_scaffold.dart';

class StoreDetailsScreen extends StatelessWidget {
  const StoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreCubit, StoreStates>(
      builder: (context, state) {
        final cubit = StoreCubit.get(context);
        return CustomScaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(

                children: [
                  ConditionalBuilder(condition: state is !GetAllRestaurantsLoadingState&&cubit.restaurant!=null,
                      builder: (context) => Column(
                        children: [
                          Image.network(cubit.restaurant!.bannerImage!,
                            width: double.infinity,
                            height: 170.h,
                            fit: BoxFit.fill,
                          ).animate()
                              .fadeIn(duration: 600.ms)
                              .scale(begin: Offset(1.1, 1.1), curve: Curves.easeOut),
                          SizedBox(
                            height: 40.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              spacing: 8.w,
                              children: [
                                _buildFilterChip(context, "main_menu".tr(), FoodFilter.all),
                                _buildFilterChip(context, "meals".tr(), FoodFilter.meals),
                                _buildFilterChip(context, "sandwiches".tr(), FoodFilter.sandwiches),
                              ],
                            ).animate().slideX(begin: -0.2, duration: 400.ms).fadeIn(),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 25.h,
                                childAspectRatio: 1,
                              ),
                              itemCount: cubit.filteredMenu.length,
                              itemBuilder: (context, index) {
                                final item = cubit.filteredMenu[index];

                                return GestureDetector(
                                  onTap: () {
                                    cubit.getSandwichDetails(cubit.filteredMenu[index].id);
                                    navigateTo(context, SandwichDetailsScreen());
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child:item.imageFullUrl==null?
                                        SizedBox(
                                          width: 100.w,
                                          height: 100.w,
                                          child: Icon(
                                            Icons.image,
                                            size: 28.w,
                                            color: Colors.grey,
                                          ),
                                        ):
                                        Image.network(
                                          item.imageFullUrl!,
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
                                      Column(
                                        crossAxisAlignment:  CrossAxisAlignment.start,
                                        children: [
                                          text12Style(text: item.name!,
                                              fontFamily: "madMd"),
                                          RichText(
                                            text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: item.price.toString(),
                                                    style: TextStyle(
                                                        fontFamily:"madReg",
                                                        fontSize: 12.sp,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "pound".tr(),
                                                    style: TextStyle(
                                                        fontFamily:"madReg",
                                                        fontSize: 12.sp,
                                                        color: Color(0xffA2A2A2)
                                                    ),
                                                  )
                                                ]
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                    .animate(delay: (100 * index).ms) // stagger
                                    .fadeIn(duration: 400.ms)
                                    .slideY(begin: 0.2, curve: Curves.easeOut);
                              },
                            ),
                          ),

                        ],
                      ), fallback: (context) => Center(
                        child: CircularProgressIndicator(
                          color: Color(mainColor),
                        ),
                      )
                  ),
                  Positioned(
                    top: 70.h,
                    left:  30.w ,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.white,
                        ),
                        padding: WidgetStateProperty.all(EdgeInsets.all(7)), // smaller padding
                        minimumSize: WidgetStateProperty.all(Size(20.w, 20.w)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        context.locale.languageCode == 'ar'
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios_new,
                        color: Color( mainColor),
                        size: 17.w,
                      ),
                    ),
                  ),
                  if(cubit.restaurant!=null)
                  Positioned(
                    top: 140.h,
                    right: context.locale.languageCode == 'ar' ? 30.w : null,
                    left: context.locale.languageCode == 'en' ? 30.w : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        Container(
                          width: 78.w,
                          height: 78.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(image: NetworkImage(cubit.restaurant!.logo!),
                                  fit: BoxFit.contain
                              ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1), // subtle shadow
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4), // moves shadow down
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text14Style(text: cubit.restaurant!.name!),
                            text12Style(text: cubit.restaurant!.category[0].name!,color: Color(0xff787878))
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )
          ),
        );
      },
    );
  }

}

Widget _buildFilterChip(BuildContext context, String label, FoodFilter filter) {
  final cubit = StoreCubit.get(context);
  final isSelected = cubit.selectedSandwichFilter == filter;
  print(isSelected);
  return GestureDetector(
    onTap: () => cubit.changeFilter(filter),
    child: Container(
      height: 30.h,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: ShapeDecoration(
        color: isSelected ? Color(mainColor) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? Color(mainColor) : const Color(0xFFE1E1E1),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Center(
        child: text10Style(
          text: label,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}
