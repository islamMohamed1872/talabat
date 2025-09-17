import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/models/user_session_singleton.dart';
import 'package:foodapp/modules/home/cubit/home_states.dart';
import 'package:foodapp/modules/home/home_screen.dart';
import 'package:foodapp/modules/profile/profile_screen.dart';
import 'package:foodapp/modules/store/store_screen.dart';
import 'package:foodapp/network/const.dart';
import 'package:foodapp/network/remote/dio_helper.dart';

import '../../../models/ads_model.dart';
import '../../../models/categories_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeCurrentIndex(int value) {
    currentIndex = value;
    emit(ChangeCurrentIndexState());
  }

  List screens = [HomeScreen(), StoreScreen(), HomeScreen(), ProfileScreen()];

  var searchController = TextEditingController();

  int currentSliderIndex = 0;
  final List<Widget> sliderItems = [

  ];
  void changeSliderIndex(int index) {
    currentSliderIndex = index;
    emit(ChangeSliderIndexState());
  }
  List<CategoryModel> categories = [];


  List colors = [0xff795548,0xffE91E63,0xff4FC3F7,0xff7F3217,0xff81D4FA,
  0xff8BC34A,0xffE99000,0xffF57F17,0xffF75F00];

  void getCategories(){
    emit(GetCategoriesLoadingState());
    DioHelper.getData(url: getCategoriesUrl,
    token: UserSession().token
    ).then((onValue){
      final List<dynamic> data = onValue.data;
      categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      emit(GetCategoriesSuccessState());
    }).catchError((onError){
      print(onError.response);
      emit(GetCategoriesErrorState());
    });
  }


  List<AdModel> ads = [];

  void getAds(){
    emit(GetAdsLoadingState());
    DioHelper.getData(url: getAdsUrl,
    token: UserSession().token
    ).then((onValue){
      final List<dynamic> data = onValue.data;
      ads = data.map((e) => AdModel.fromJson(e)).toList();
      for(int i = 0 ; i < 4 ;i++){
        sliderItems.add(Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(1.00, 0.50),
              end: Alignment(0.00, 0.50),
              colors: [const Color(0xB2F75F00), const Color(0xFFF75F00)],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child:ads[i].coverImageFullUrl!=null?
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(ads[i].coverImageFullUrl!,
            fit: BoxFit.fill,),
          ):null,
        ));
      }
      emit(GetAdsSuccessState());
    }).catchError((onError){
      print(onError);
      emit(GetAdsErrorState());
    });
  }

}
