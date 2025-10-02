import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/controllers/login/login_cubit.dart';
import 'package:foodapp/services/network/dio_helper.dart';
import 'package:foodapp/views/login/login_screen.dart';
import 'package:foodapp/views/cart/cart_screen.dart';
import 'package:foodapp/controllers/cart/cart_cubit.dart';
import 'package:foodapp/controllers/home/home_cubit.dart';
import 'package:foodapp/controllers/profile/profile_cubit.dart';
import 'package:foodapp/controllers/store/store_cubit.dart';
import 'services/storage/cache_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Set status bar (notification bar) color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFFF7119), // your color here
    statusBarIconBrightness: Brightness.light, // light = white icons, dark = black icons
  ));

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: Locale('ar'),
      startLocale: Locale('ar'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit(),),
          BlocProvider(create: (context) => CartCubit(),),
          BlocProvider(create: (context) => HomeCubit()..getCategories()..loadCachedZone(),),
          BlocProvider(create: (context) => ProfileCubit()..loadPreferences(),),
          BlocProvider(create: (context) => StoreCubit()..getRestaurants(),),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: LoginScreen(),
        ),
      ),
    );
  }
}

