import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:foodapp/modules/auth/register/cubit/register_states.dart';
import 'package:foodapp/network/const.dart';
import 'package:foodapp/network/remote/dio_helper.dart';

import '../../../../components/const.dart';
class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit():super(RegisterInitialState());
  static RegisterCubit get(context)=>BlocProvider.of(context);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  String countryCode = "+20";
  bool hidePassword = true;
  void togglePassword(){
    hidePassword = !hidePassword;
    emit(TogglePasswordState());
  }
  
  void createAccount(){
    emit(CreateAccountLoadingState());
    var data = json.encode({
      "name": "${firstNameController.text} ${lastNameController.text}",
      "phone": "$countryCode${phoneController.text}",
      "password": passwordController.text,
      "email" :emailController.text
    });
    DioHelper.postData(
        url: registerUrl,
        data: data).then((onValue){
          print(onValue);
          emit(CreateAccountSuccessState());
    }).catchError((onError){
      if (onError.response != null && onError.response.data["errors"] != null) {
        List errors = onError.response.data["errors"];
        print(onError.response);
        print(phoneController.text);
        for (var error in errors) {
          String code = error["code"];
          String message = _mapErrorToMessage(code);

          showToastMessage(
            message: message,
            color: Colors.red,
          );
        }
      } else {
        showToastMessage(
          message: "Unexpected error occurred",
          color: Colors.red,
        );
      }
      emit(CreateAccountErrorState());
    });
  }

  String _mapErrorToMessage(String code) {
    switch (code) {
      case "phone":
        return "phone_taken".tr(); // localized
      case "email":
        return "email_taken".tr();
      case "password":
        return "password_short".tr();
      default:
        return "unexpected_error".tr(); // fallback to backend msg
    }
  }
}

