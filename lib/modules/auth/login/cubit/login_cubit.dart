import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:foodapp/components/const.dart';
import 'package:foodapp/models/user_session_singleton.dart';
import 'package:foodapp/modules/auth/login/cubit/login_states.dart';
import 'package:foodapp/network/const.dart';
import 'package:foodapp/network/remote/dio_helper.dart';
class LoginCubit extends Cubit<LoginStates>{
  LoginCubit():super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool hidePassword = true;
  void togglePassword(){
    hidePassword = !hidePassword;
    emit(TogglePasswordState());
  }


  void login(){
    emit(LoginLoadingState());
    var data = json.encode({
      "login_type": "manual",
      "email_or_phone": emailController.text,
      "password": passwordController.text,
      "field_type": "email"
    });
    DioHelper.postData(
        url: loginUrl,
        data: data).then((onValue){
          UserSession().loadFromResponse(response: onValue);
          emit(LoginSuccessState());
    }).catchError((onError){
      showToastMessage(message: "invalid_credentials".tr(), color: Colors.red);
      emit(LoginErrorState());
    });
  }
}

