import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/modules/store/cubit/store_states.dart';

class StoreCubit extends Cubit<StoreStates>{
  StoreCubit():super(StoreInitialState());
  static StoreCubit get(context) => BlocProvider.of(context);
  var searchController = TextEditingController();

  // Sample restaurant data - replace with actual data from API
  List<Map<String, dynamic>> restaurants = [
    {
      'name': 'مطعم زكس',
      'rating': 5.0,
      'deliveryTime': '30',
      'imagePath': 'assets/images/restaurant1.png', // Jack's restaurant logo
    },
    {
      'name': 'مطعم زكس',
      'rating': 4.7,
      'deliveryTime': '30',
      'imagePath': 'assets/images/restaurant1.png', // Jack's restaurant logo
    },
    {
      'name': 'مطعم زكس',
      'rating': 4.5,
      'deliveryTime': '30',
      'imagePath': 'assets/images/restaurant1.png', // Jack's restaurant logo
    },
    {
      'name': 'مطعم زكس',
      'rating': 4.0,
      'deliveryTime': '30',
      'imagePath': 'assets/images/restaurant1.png', // Jack's restaurant logo
    },
    {
      'name': 'مطعم زكس',
      'rating': 4.7,
      'deliveryTime': '30',
      'imagePath': 'assets/images/restaurant1.png', // Jack's restaurant logo
    },
  ];

  // Method to filter restaurants based on search
  void searchRestaurants(String query) {
    // Implement search logic here
    // You can filter the restaurants list based on the query
    emit(StoreSearchState());
  }

  // Method to sort restaurants
  void sortRestaurants(String sortBy) {
    if (sortBy == "rating") {
      restaurants.sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (sortBy == "deliveryTime") {
      restaurants.sort((a, b) =>
          int.parse(a['deliveryTime']).compareTo(int.parse(b['deliveryTime'])));
    }
    emit(StoreSortState());
  }

  // Method to filter by category
  void filterByCategory(String category) {
    // Implement category filtering logic here
    emit(StoreCategoryFilterState());
  }

  String selectedSortOption = "rating"; // default option
  String selectedFilter = "rating" ;
  void changeSelectedFilter(String value){
    selectedFilter = value;
    emit(ChangeSelectedFilterState());
  }

  String? selectedSandwichOption = "ساندوتش"; // default selected

  final List<Map<String, String>> options = [
    {"label": "sandwich", "price": ""},
    {"label": "family_size_small", "price": "+30 جنيه"},
    {"label": "family_size_medium", "price": "+60 جنيه"},
    {"label": "family_size_large", "price": "+90 جنيه"},
  ];
  void changeSelectedSandwichOption(String value){
    selectedSandwichOption = value;
    emit(ChangeSelectedSandwichOptionState());
  }
  // Ingredients with counts
  List<Map<String, dynamic>> ingredients = [
    {"name": "lettuce", "count": 1},
    {"name": "tomato", "count": 1},
    {"name": "cheddar_sauce", "count": 0},
  ];

  void increaseIngredient(String name) {
    final index = ingredients.indexWhere((i) => i['name'] == name);
    if (index != -1) {
      ingredients[index]['count']++;
      emit(ChangeSelectedFilterState()); // trigger rebuild
    }
  }

  void decreaseIngredient(String name) {
    final index = ingredients.indexWhere((i) => i['name'] == name);
    if (index != -1 && ingredients[index]['count'] > 0) {
      ingredients[index]['count']--;
      emit(ChangeSelectedFilterState());
    }
  }
  int selectedItemCount = 1;
  void increaseSelectedItem() {
    selectedItemCount++;
    emit(ChangeSelectedFilterState()); // trigger rebuild
  }

  void decreaseSelectedItem() {
    if ( selectedItemCount > 0) {
      selectedItemCount--;
      emit(ChangeSelectedFilterState());
    }
  }
}