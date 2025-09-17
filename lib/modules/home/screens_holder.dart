import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/modules/home/cubit/home_cubit.dart';
import 'package:foodapp/modules/home/cubit/home_states.dart';

import '../../components/custom_nav_bar.dart';

class ScreensHolder extends StatelessWidget {
  const ScreensHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return CustomScaffold(
              body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeCurrentIndex(index);
              },
            ),
          );
        },);
  }
}
