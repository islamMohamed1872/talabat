import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/cache_helper/cache_helper.dart';
import 'package:foodapp/modules/profile/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  ProfileCubit():super(ProfileInitialState());
  static ProfileCubit get(context)=> BlocProvider.of(context);

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

  var nameController = TextEditingController(text: "محمود شحاتة سعدالدين");
  var emailController = TextEditingController(text: "midos2290@yahoo.com");
  var phoneController = TextEditingController(text: "01113451800");
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

}