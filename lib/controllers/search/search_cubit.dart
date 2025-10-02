import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/controllers/search/search_states.dart';
import 'package:foodapp/models/user_session_singleton.dart';

import '../../config/api_const.dart';

import '../../models/search_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(BuildContext context) => BlocProvider.of(context);

  final searchController = TextEditingController();

  List<SearchedFood> searchedFood = [];
  List<SearchedRestaurant> searchedRestaurant = [];

  void getSearchResults() {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': 'en',
      'X-localization': 'en',
      'zoneId': '[1]',
      'latitude': '0',
      'Longitude': '0',
      'Authorization': "Bearer ${UserSession().token}",
    };
    var dio = Dio();

    final query = searchController.text.trim();
    print(query);
    if (query.isEmpty) {
      emit(GetSearchResultsErrorState());
      return;
    }

    emit(GetSearchResultsLoadingState());

    dio.request(
      '$getSearchResultUrl?name=$query',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    ).then((response) {
      try {
        final data = response.data;
        print(data);
        searchedFood = (data['foods'] as List<dynamic>)
            .map((e) => SearchedFood.fromJson(e))
            .toList();

        searchedRestaurant = (data['restaurants'] as List<dynamic>)
            .map((e) => SearchedRestaurant.fromJson(e))
            .toList();
        print(searchedRestaurant);
        print(searchedFood);
        emit(GetSearchResultsSuccessState());
      } catch (e) {
        print(e);
        emit(GetSearchResultsErrorState());
      }
    }).catchError((error) {
      print(error.response);
      emit(GetSearchResultsErrorState());
    });
  }
}
