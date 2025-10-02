import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:foodapp/models/user_session_singleton.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio();
    //
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
  }

  static Future<Response> getData({
    required String url,
    String? token,
    Map<String, dynamic>? queryParams,
    var data,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'zoneId': '[1]',
      // 'zoneId': '[${UserSession().zoneId}]',
      'Authorization':  token != null ? "Bearer $token" : "",
    };
    return await dio.get(
      url,
      queryParameters: queryParams,
      data: data??''''''
    );
  }


  static Future<Response> postData({
    required String url,
    required var data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':  token != null ? "Bearer $token" : "",
      'Accept': 'application/json',
    };
    return await dio.post(
      url,
      data: data,
      queryParameters: queryParameters
    );
  }

  static Future<Response> patchData({
    required String url,
    required var data,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':  token != null ? "Bearer $token" : "",
    };
    return await dio.patch(
      url,
      data: data,
      queryParameters: queryParams
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':  token != null ? "Bearer $token" : "",
    };
    return await dio.delete(
        url,
        queryParameters: queryParams
    );
  }
  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    // Check if data is FormData (multipart)
    if (data is FormData) {
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': token != null ? "Bearer $token" : "",
      };
    } else {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Authorization': token != null ? "Bearer $token" : "",
      };
    }

    return await dio.put(
      url,
      data: data,
      queryParameters: queryParams,
    );
  }


  static Future<Response> postWithCustomHeaders({
    required String url,
    required var data,
    required Map<String, String> headers,
  }) async {
    dio.options.headers = headers;

    return await dio.post(
      url,
      data: data,
    );
  }

}
