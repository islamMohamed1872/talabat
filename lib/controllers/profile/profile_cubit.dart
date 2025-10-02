import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/services/storage/cache_helper.dart';
import 'package:foodapp/controllers/profile/profile_states.dart';
import 'package:foodapp/models/user_model.dart';
import 'package:foodapp/models/user_session_singleton.dart';
import '../../config/api_const.dart';
import '../../services/network/dio_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/orders_model.dart';
import '../../models/wollet_model.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  ProfileCubit():super(ProfileInitialState());
  static ProfileCubit get(context)=> BlocProvider.of(context);

  UserModel user = UserSession().user!;

  // Languages
  final List<String> languages = ["ar", "en"];
  String selectedLanguage = "ar";

  // Countries
  final List<String> countries = ["Egypt", "UAE", "KSA", "Qatar"];
  String selectedCountry = "Egypt";

  /// Load saved language/country from SharedPreferences
  Future<void> loadPreferences() async {
    selectedLanguage = CacheHelper.getData(key: "selectedLanguage") ?? "ar";
    selectedCountry = CacheHelper.getData(key: "selectedCountry") ?? "Egypt";
    emit(ProfileInitialState()); // triggers UI update with cached values
  }

  void changeLanguage(String value) {
    selectedLanguage = value;
    CacheHelper.putDate(key: "selectedLanguage",data: value );
    emit(ProfileLanguageChangedState());
  }

  void changeCountry(String value) {
    selectedCountry = value;
    CacheHelper.putDate(key: "selectedCountry",data: value );
    emit(ProfileCountryChangedState());
  }

  var nameController = TextEditingController(text: UserSession().user!.firstName);
  var emailController = TextEditingController(text: UserSession().user!.email);
  var phoneController = TextEditingController(text: UserSession().user!.phone);
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  WalletDetails? walletDetails;

  void getWalletDetails() {
    emit(GetWalletDetailsLoadingState());

    DioHelper.getData(
      url: getWalletDetailsUrl,
      token: UserSession().token,
    ).then((response) {
      // parse
      walletDetails = WalletDetails.fromJson(response.data);

      emit(GetWalletDetailsSuccessState());
    }).catchError((error) {
      print("getWalletDetails error: $error");
      emit(GetWalletDetailsErrorState());
    });
  }

  File? profileImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> pickProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // or ImageSource.camera
        imageQuality: 70, // compress to save space
      );

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        uploadProfileImage();
        emit(ProfileImagePickedState());
      } else {
        // User canceled
        emit(ProfileImagePickCancelledState());
      }
    } catch (e) {
      print("pickProfileImage error: $e");
      emit(ProfileImagePickErrorState());
    }
  }

  void uploadProfileImage()async {
    emit(UploadProfileImageLoadingState());
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(profileImage!.path),
      "email": emailController.text,
    });
    DioHelper.postData(
      url: uploadProfileImageUrl,
      data: formData,
      token: UserSession().token,
    ).then((response) {
      print(response.data);
      emit(UploadProfileImageSuccessState());
    }).catchError((error) {
      print("uploadProfileImage error: ${error.response}");
      emit(UploadProfileImageErrorState());
    });

  }

  void updateUserInfo(){
    emit(UpdateUserInfoLoadingState());
    var data = json.encode({
      "f_name": nameController.text,
      "l_name": user.lastName,
      "email": emailController.text,
      "phone": phoneController.text,
    });

    DioHelper.postData(
        url: updateUserInfoUrl,
        data: data,
    token: UserSession().token
    ).then((onValue){
      print(onValue);
      emit(UpdateUserInfoSuccessState());
    }).catchError((onError){
      print(onError);
      emit(UpdateUserInfoErrorState());
    });

  }
  List<OrderModel> orders = [];

  void getOrders() {
    emit(GetOrdersLoadingState());

    DioHelper.getData(
      url: "$getAllOrdersUrl?limit=10&offset=1&status=running",
      token: UserSession().token
    ).then((response) {
      try {
        // Parse JSON into model
        final data = OrdersResponse.fromJson(response.data);

        // Save orders
        orders = data.orders;

        emit(GetOrdersSuccessState());
      } catch (e) {
        print("Parse error: $e");
        emit(GetOrdersErrorState());
      }
    }).catchError((error) {
      print("Request error: $error");
      emit(GetOrdersErrorState());
    });
  }

  String formatDateTime(String? rawDateTime,BuildContext context) {
    if (rawDateTime == null || rawDateTime.isEmpty) return "—";

    try {
      final dateTime = DateTime.parse(rawDateTime);

      // Format: 04/08/2025 09:13 صباحا
      final formatted = DateFormat("dd/MM/yyyy hh:mm a", "en").format(dateTime);

      // Replace AM/PM with Arabic terms
      if(context.locale.languageCode=="ar"){
        return formatted
            .replaceAll("AM", "صباحا")
            .replaceAll("PM", "مساءً");
      }
      return formatted;
    } catch (e) {
      return rawDateTime; // fallback if parsing fails
    }
  }

}