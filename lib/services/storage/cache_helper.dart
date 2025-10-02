import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
  sharedPreferences = await SharedPreferences.getInstance();
  }
  static void putDate({required String key,required dynamic data}) {
    if(data is int)
      {
        sharedPreferences.setInt(key, data);
      }
    else if(data is String){
      sharedPreferences.setString(key, data);
    }
    else if(data is bool){
      sharedPreferences.setBool(key, data);
    }
    else if(data is double){
      sharedPreferences.setDouble(key, data);
    }
    else if(data is List<String>){
      sharedPreferences.setStringList(key, data);
    }
    else if(data is List<dynamic>){
      List<String> stringList = data.map((dynamic item) => item.toString()).toList();
      sharedPreferences.setStringList(key, stringList);
    }
  }
  static dynamic getData({required String key}){
    return sharedPreferences.get(key);
  }
  static dynamic saveMap({required String key, required Map<String,dynamic> data}) async {
    String jsonString = sharedPreferences.getString(key) ?? '{}';
    Map<String, dynamic> existingData = json.decode(jsonString);

    // Merge the existing data with the new data
    existingData.addAll(data);

    await sharedPreferences.setString(key, json.encode(existingData));
  }
  static Map<String, dynamic>? getMap({required String key}) {
    String? jsonString = sharedPreferences.getString(key);
    return jsonString==null?null: json.decode(jsonString);
  }
  static Future<bool> removeKey({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}