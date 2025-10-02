import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/services/storage/cache_helper.dart';
import 'package:foodapp/models/user_model.dart';
import 'package:foodapp/controllers/cart/cart_states.dart';
import 'package:foodapp/controllers/home/home_cubit.dart';
import '../../config/api_const.dart';
import '../../services/network/dio_helper.dart';
import '../../services/storage/cartDB.dart';
import '../../views/widgets/const.dart';
import '../../models/sandwich_model.dart';
import '../../models/user_session_singleton.dart';


class CartCubit extends Cubit<CartStates>{
  CartCubit():super(CartInitialState());
  static CartCubit get(context) => BlocProvider.of(context);

  var addressController = TextEditingController();
  var noteController = TextEditingController();
  List items = [];
  Future<void> loadCart(context) async {
    emit(LoadCartLoadingState());
    items = await CartDatabase.instance.getItems();
    addressController.text = HomeCubit.get(context).address;
    emit(LoadCartSuccessState());
  }

  Future<void> addItem(Map<String, dynamic> item,context) async {
    await CartDatabase.instance.addItem(item);
    await loadCart(context);
  }

  Future<void> updateItem(Map<String, dynamic> item,context) async {
    await CartDatabase.instance.updateItem(item);
    await loadCart(context);
  }

  Future<void> removeItem(int id,context) async {
    await CartDatabase.instance.deleteItem(id);
    await loadCart(context);
  }

  Future<void> clearCart() async {
    await CartDatabase.instance.clearCart();
    items = await CartDatabase.instance.getItems();
   emit(LoadCartSuccessState());
  }

  int selectedItemIndex = -1;
  void changeSelectedItem(int id) {
    selectedItemIndex = id;
    emit(ChangeSelectedItemState());
  }

  int selectedItemId = -1;
  void changeSelectedItemId(int id) {
    selectedItemId = id;
    emit(ChangeSelectedItemState());
  }

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

  String? selectedSandwichOption;

  void changeSelectedSandwichOption(String value) {
    selectedSandwichOption = value;
    emit(ChangeSandwichOptionState());
  }

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

  SandwichModel? sandwichDetails;

  void getSandwichDetails(int id) async {
    emit(GetSandwichDetailsLoadingState());
    try {
      final response = await DioHelper.getData(
        url: "$getSandwichDetailsUrl/$id",
        token: UserSession().token,
      );

      sandwichDetails = SandwichModel.fromJson(response.data);

      if (selectedItemIndex != -1 && selectedItemIndex < items.length) {
        final savedItem = items[selectedItemIndex];

        // quantity
        selectedItemCount = savedItem['quantity'] ?? 1;

        // option
        selectedSandwichOption = savedItem['options'];

        // ingredients: decode from string → Map
        if (savedItem['ingredients'] != null &&
            savedItem['ingredients'].toString().isNotEmpty) {
          final decoded = jsonDecode(savedItem['ingredients'].toString());
          print(decoded);

          if (decoded is List) {
            print(1);
            // multiple ingredients saved
            ingredients = decoded.map<Map<String, dynamic>>((i) => {
              "name": i['name'],
              "count": i['count'] ?? 0,
              'id': i['id']
            }).toList();
          } else if (decoded is Map) {
            print(2);
            // single ingredient saved
            ingredients = [
              {"name": decoded['name'], "count": decoded['count'] ?? 0, "id": decoded['id']}
            ];
          }
        } else {
          print(3);
          // fallback: from API
          ingredients = sandwichDetails!.addOns
              .map((addon) => {"name": addon.name, "count": 0,'id':addon.id})
              .toList();
        }
      } else {
        print(4);
        // no saved item → defaults
        selectedItemCount = 1;
        if (sandwichDetails!.variations.isNotEmpty) {
          selectedSandwichOption =
              sandwichDetails!.variations.first.values.first.label;
        }
        ingredients = sandwichDetails!.addOns
            .map((addon) => {"name": addon.name, "count": 0, "id": addon.id})
            .toList();
      }

      emit(GetSandwichDetailsSuccessState());
    } catch (error) {
      print(error);
      emit(GetSandwichDetailsErrorState());
    }
  }

  Future<void> updateDatabaseItem({
    required String productId,
    required int id,
    required String name,
    required String image,
    required String description,
    required double price,
    required String options,
    required List<Map<String, dynamic>> ingredients,
    required context
  })async{
    double totalPrice = 0;

    // base price × quantity
    totalPrice += price * selectedItemCount;

    // add option price
    if (sandwichDetails != null && selectedSandwichOption != null) {
      for (var variation in sandwichDetails!.variations) {
        for (var val in variation.values) {
          if (val.label == selectedSandwichOption) {
            totalPrice += (val.optionPrice * selectedItemCount);
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
      'id':id,
      'productId': productId.toString(),
      'name': name,
      'price': price,
      'image' :image,
      'description': description,
      'quantity': selectedItemCount,
      'options': options,
      'ingredients': jsonEncode(ingredients),
      'totalPrice': totalPrice,
    };
    print(item);
    await CartDatabase.instance.updateItem(item).then((onValue){
      print(onValue);
      loadCart(context);
      // Confirmation
      showToastMessage(message: "added_to_cart".tr(), color: Color(mainColor));
    }).catchError((onError){
      print(onError);
    });
  }


  // flag to update lat and lng
  bool addressChanged = false;
  Future<Map<String, double>> addressToLatLng() async {
    const apiKey = "AIzaSyDSG1JvtmERikUhwGhdRupHGbYVHqEX_xA";
    final url = "https://maps.googleapis.com/maps/api/geocode/json"
        "?address=${Uri.encodeComponent(addressController.text)}&key=$apiKey";

    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      if (data["status"] == "OK") {
        final location = data["results"][0]["geometry"]["location"];
        return {
          "lat": location["lat"],
          "lng": location["lng"],
        };
      } else {
        throw Exception("Geocoding API error: ${data["status"]}");
      }
    } else {
      throw Exception("Failed to fetch geocoding data");
    }
  }


  List<Map<String, dynamic>> parseIngredients(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      } catch (e) {
        print("Error decoding ingredients: $e");
      }
    }
    return [];
  }




  void checkOut(context) async {
    emit(CheckOutLoadingState());
    double lat = 0;
    double lng = 0;

    if (addressChanged) {
      final latLng = await addressToLatLng();
      lat = latLng['lat'] ?? 0.0;
      lng = latLng['lng'] ?? 0.0;
    } else {
      lat = (await CacheHelper.getData(key: "lat")) ?? 0.0;
      lng = await CacheHelper.getData(key: "lng") ?? 0.0;
    }

    UserModel user = UserSession().user!;
    print("Items: $items");

    // Group items by restaurant_id (in case the user didn't add the items from each restaurant at the same time)
    Map<int, List<Map<String, dynamic>>> groupedByRestaurant = {};
    for (var item in items) {
      int restId = item['restaurant_id'];
      groupedByRestaurant.putIfAbsent(restId, () => []).add(item);
    }

    // Build restaurants array
    List<Map<String, dynamic>> restaurants = [];
    groupedByRestaurant.forEach((restId, restItems) {
      double orderAmount = 0.0;
      List<Map<String, dynamic>> cart = [];

      for (var item in restItems) {
        // Ensure numbers are parsed
        final price = double.tryParse(item['price'].toString()) ?? 0.0;
        final totalPrice = double.tryParse(item['totalPrice']?.toString() ?? '') ?? price;
        final qty = int.tryParse(item['quantity'].toString()) ?? 1;

        final ingredients = parseIngredients(item['ingredients']);
        orderAmount += totalPrice * qty;

        cart.add({
          "item_id": item['id'],
          "item_type": item['item_type'] ?? "App\\Models\\Food",
          "price": price,
          "quantity": qty,
          "variations": [],
          "variation_options": [],
          "add_on_ids": ingredients.map((i) => i['id']).toList(),
          "add_on_qtys": ingredients.map((i) => i['count']).toList(),
        });
      }

      restaurants.add({
        "restaurant_id": restId,
        "order_amount": orderAmount,
        "is_buy_now": 1,
        "cart": cart,
      });
    });


    // Final payload
    var data = {
      "payment_method": "cash_on_delivery", // or visa, etc.
      "order_type": "delivery",
      "distance": 1.0,
      "address": HomeCubit.get(context).address,
      "latitude": 22.68929486441163,
      "longitude": 90.40275353466794,
      // "longitude": lat,
      // "latitude": lng,
      "contact_person_name": user.firstName,
      "contact_person_number": user.phone,
      "guest_id": user.id.toString(),
      "restaurants": restaurants,
    };

    print("Checkout data: $data");

    DioHelper.postData(
      url: placeOrderUrl,
      data: data,
      token: UserSession().token,
    ).then((onValue) {
      print(onValue);

      if (onValue.data != null && onValue.data["results"] is List) {
        for (var result in onValue.data["results"]) {
          final status = result["status"];
          final restId = result["restaurant_id"];

          if (status == 200) {
            showToastMessage(
              message: "order_success".tr(),
              color: Color(mainColor),
            );
            markOrderPlaced();
            clearCart();
            emit(CheckOutSuccessState());

          } else if (status == 403) {
            // ❌ Errors
            final errors = result["data"]["errors"] as List?;
            if (errors != null && errors.isNotEmpty) {
              for (var err in errors) {
                final code = err["code"];
                final msg = err["message"];

                if (code == "coordinates") {
                  showToastMessage(
                    message: "out_of_coverage".tr(), // localized key
                    color: Colors.red,
                  );
                } else if (code == "schedule_at") {
                  showToastMessage(
                    message: "restaurant_closed".tr(), // localized key
                    color: Colors.red,
                  );
                } else {
                  showToastMessage(
                    message: msg ?? "order_failed".tr(),
                    color: Colors.red,
                  );
                }
              }
            }
            emit(CheckOutErrorState());
          } else {
            // Unexpected status
            showToastMessage(
              message: "order_failed".tr(),
              color: Colors.red,
            );
            emit(CheckOutErrorState());
          }
        }
      } else {
        showToastMessage(
          message: "order_failed".tr(),
          color: Colors.red,
        );
        emit(CheckOutErrorState());
      }
    }).catchError((onError) {
      print(onError);
      showToastMessage(
        message: "generic_error".tr(),
        color: Colors.red,
      );
      emit(CheckOutErrorState());
    });

  }
  bool orderPlaced = false;
  void markOrderPlaced() {
    orderPlaced = true;
    emit(CheckOutSuccessState());
  }

  void resetOrderPlaced() {
    orderPlaced = false;
    emit(CartInitialState());
  }

}