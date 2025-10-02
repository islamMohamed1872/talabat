import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/models/restaurant_details_model.dart';
import 'package:foodapp/models/user_session_singleton.dart';
import '../../controllers/store/store_states.dart';
import '../../config/api_const.dart';
import '../../services/network/dio_helper.dart';

import '../../services/storage/cartDB.dart';
import '../../models/restaurant_model.dart';
import '../../models/sandwich_model.dart';

enum RestaurantFilter {
  all,
  freeDelivery,
  pickupOnly,
  deliveryTime,
}

///store details screen
enum FoodFilter { all, meals, sandwiches }


class StoreCubit extends Cubit<StoreStates>{
  StoreCubit():super(StoreInitialState());
  static StoreCubit get(context) => BlocProvider.of(context);
  var searchController = TextEditingController();

  List<Restaurant> restaurants = [];
  List<Restaurant> filteredRestaurants = [];

  RestaurantFilter selectedFilter = RestaurantFilter.all;

  void getRestaurants() {
    emit(GetAllRestaurantsLoadingState());
    DioHelper.getData(
      url: getAllRestaurantsUrl,
      token: UserSession().token,
    ).then((onValue) {
      try {
        final data = onValue.data;
        final restaurantResponse = RestaurantResponse.fromJson(data);

        restaurants = restaurantResponse.restaurants;
        filteredRestaurants = List.from(restaurants);

        emit(GetAllRestaurantsSuccessState());
      } catch (e) {
        print(e);
        emit(GetAllRestaurantsErrorState());
      }
    }).catchError((onError) {
      print(onError);
      emit(GetAllRestaurantsErrorState());
    });
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredRestaurants = restaurants;
    } else {
      filteredRestaurants = restaurants
          .where((r) => r.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(StoreSearchState());
  }

  String selectedSortOption = "rating";

  /// Sort restaurants
  void sortRestaurants(String sortBy) {
    if (sortBy == "rating") {
      filteredRestaurants.sort((a, b) => b.avgRating.compareTo(a.avgRating));
    } else if (sortBy == "deliveryTime") {
      int parseTime(String time) {
        final match = RegExp(r'(\d+)').firstMatch(time);
        return match != null ? int.parse(match.group(1)!) : 0;
      }

      filteredRestaurants.sort(
            (a, b) => parseTime(a.deliveryTime!).compareTo(parseTime(b.deliveryTime!)),
      );
    }
    selectedSortOption = sortBy;
    emit(StoreSortState());
  }



  /// Filter
  void filterRestaurants(RestaurantFilter filter) {
    selectedFilter = filter;

    if (filter == RestaurantFilter.all) {
      filteredRestaurants = restaurants;
    } else if (filter == RestaurantFilter.freeDelivery) {
      filteredRestaurants =
          restaurants.where((r) => r.freeDelivery == true).toList();
    } else if (filter == RestaurantFilter.pickupOnly) {
      filteredRestaurants =
          restaurants.where((r) => r.pickupOnly == true).toList();
    } else if (filter == RestaurantFilter.deliveryTime) {
      int parseTime(String time) {
        final match = RegExp(r'(\d+)').firstMatch(time);
        return match != null ? int.parse(match.group(1)!) : 999;
      }

      filteredRestaurants =
          restaurants.where((r) => parseTime(r.deliveryTime!) <= 20).toList();
    }
    emit(StoreCategoryFilterState());
  }
  /// Update selected filter manually
  void changeSelectedFilter(RestaurantFilter value) {
    selectedFilter = value;
    emit(ChangeSelectedFilterState());
  }

  /// store details screen
  RestaurantDetailsModel? restaurant;
  void getStoreDetails(int index) {
    emit(GetRestaurantDetailsLoadingState());

    DioHelper.getData(
      url: "$getRestaurantDetailsUrl/$index/brief",
      token: UserSession().token,
    ).then((response) {

      try {
        restaurant = RestaurantDetailsModel.fromJson(response.data);
        print(restaurant);
        emit(GetRestaurantDetailsSuccessState());
      } catch (e) {
        print(e);
        emit(GetRestaurantDetailsErrorState());
      }
    }).catchError((error) {
      print(error);
      emit(GetRestaurantDetailsErrorState());
    });
  }

  FoodFilter selectedSandwichFilter = FoodFilter.all;

  void changeFilter(FoodFilter filter) {
    selectedSandwichFilter = filter;
    emit(ChangeSelectedFilterState()); // trigger rebuild
  }


  List<MenuItem> get filteredMenu {
    if (restaurant == null) return [];
    switch (selectedSandwichFilter) {
      case FoodFilter.meals:
        return restaurant!.menu.where((f) => f.type == "meal").toList();
      case FoodFilter.sandwiches:
        return restaurant!.menu.where((f) => f.type == "sandwich").toList();
      case FoodFilter.all:
      default:
        return restaurant!.menu;
    }
  }


  SandwichModel? sandwichDetails;

  /// sandwich details screen
  void getSandwichDetails(int id) async {
    emit(GetSandwichDetailsLoadingState());
    try {
      final response = await DioHelper.getData(
        url: "$getSandwichDetailsUrl/$id",
        token: UserSession().token,
      );

      sandwichDetails = SandwichModel.fromJson(response.data);

      // initialize default selections from API
      if (sandwichDetails!.variations.isNotEmpty) {
        selectedSandwichOption =
            sandwichDetails!.variations.first.values.first.label;
      }

      // map ingredients (from addOns if available)
      ingredients = sandwichDetails!.addOns
          .map((addon) => {"name": addon.name, "count": 0,'id':addon.id})
          .toList();

      emit(GetSandwichDetailsSuccessState());
    } catch (error) {
      emit(GetSandwichDetailsErrorState());
    }
  }

  // -------- Sandwich Option (Variation) --------
  String? selectedSandwichOption;

  void changeSelectedSandwichOption(String value) {
    selectedSandwichOption = value;
    emit(ChangeSandwichOptionState());
  }

  // -------- Ingredients (Add-ons) --------
  List<Map<String, dynamic>> ingredients = [];

  void increaseIngredient(String name) {
    final index = ingredients.indexWhere((i) => i['name'] == name);
    if (index != -1) {
      ingredients[index]['count']++;
      emit(ChangeSelectedFilterState());
    }
  }

  void decreaseIngredient(String name) {
    final index = ingredients.indexWhere((i) => i['name'] == name);
    if (index != -1 && ingredients[index]['count'] > 0) {
      ingredients[index]['count']--;
      emit(ChangeSelectedFilterState());
    }
  }

  // -------- Item Count --------
  int selectedItemCount = 1;

  void increaseSelectedItem() {
    selectedItemCount++;
    emit(ChangeSelectedFilterState());
  }

  void decreaseSelectedItem() {
    if (selectedItemCount > 1) {
      selectedItemCount--;
      emit(ChangeSelectedFilterState());
    }
  }




  Future<void> addToCart({
    required int productId,
    required String name,
    required String image,
    required String description,
    required double price,
    required int quantity,
    required String options,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    double totalPrice = 0;

    // base price × quantity
    totalPrice += price * quantity;

    // add option price
    if (sandwichDetails != null && selectedSandwichOption != null) {
      for (var variation in sandwichDetails!.variations) {
        for (var val in variation.values) {
          if (val.label == selectedSandwichOption) {
            totalPrice += (val.optionPrice * quantity);
          }
        }
      }
    }

    // add ingredient prices
    if (sandwichDetails != null) {
      for (var ing in ingredients) {
        final addon = sandwichDetails!.addOns.firstWhere(
              (a) => a.name == ing['name'],
          orElse: () => AddOn(id: 0, name: "", price: 0),
        );
        final count = ing['count'] ?? 0;
        totalPrice += addon.price * count;
      }
    }

    final item = {
      'productId': productId.toString(),
      'name': name,
      'price': price,
      'image' :image,
      'description': description,
      'quantity': quantity,
      "restaurant_id": restaurant!.id,
      'options': options,
      'ingredients': jsonEncode(ingredients),
      'totalPrice': totalPrice,
    };

    await CartDatabase.instance.addItem(item);
  }




}