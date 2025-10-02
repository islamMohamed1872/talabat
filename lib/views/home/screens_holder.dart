import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/controllers/home/home_cubit.dart';
import '../../controllers/home/home_states.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/custom_scaffold.dart';


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
