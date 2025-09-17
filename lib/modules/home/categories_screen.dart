import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/components/default_appbar.dart';

import '../../components/const.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        return CustomScaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                spacing: 30.h,
                children: [
                  DefaultAppBar(
                    title: "categories".tr(),
                    context: context,
                    lang: context.locale.languageCode,
                  ),
                  Expanded(
                    child: AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // 5 items per row
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10.h,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: cubit.categories.length,
                        itemBuilder: (context, index) {
                          final category = cubit.categories[index];

                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            columnCount: 5,
                            child: ScaleAnimation(
                              curve: Curves.easeOutBack,
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 55.w,
                                      height: 55.w,
                                      decoration: BoxDecoration(
                                        color: Color(
                                          cubit.colors[index % 9],
                                        ).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          category.imageFullUrl!,
                                          width: 28.w,
                                          height: 28.w,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: text10Style(
                                        text: category.name,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
