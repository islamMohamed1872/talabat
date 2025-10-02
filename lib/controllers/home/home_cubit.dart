import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/services/storage/cache_helper.dart';
import 'package:foodapp/models/user_session_singleton.dart';
import '../../controllers/home/home_states.dart';
import 'package:foodapp/views/home/home_screen.dart';
import 'package:foodapp/views/profile/profile_screen.dart';
import 'package:foodapp/views/search/search_screen.dart';
import '../../controllers/store/store_states.dart';
import '../../config/api_const.dart';
import '../../services/network/dio_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/ads_model.dart';
import '../../models/categories_model.dart';
import '../../models/popular_products_model.dart';
import '../../models/zone_model.dart';
import '../../views/store/store_screen.dart';
import '../../views/widgets/const.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeCurrentIndex(int value) {
    currentIndex = value;
    emit(ChangeCurrentIndexState());
  }

  List screens = [HomeScreen(), StoreScreen(), SearchScreen(), ProfileScreen()];

  var searchController = TextEditingController();

  int currentSliderIndex = 0;
  final List<Widget> sliderItems = [

  ];
  void changeSliderIndex(int index) {
    currentSliderIndex = index;
    emit(ChangeSliderIndexState());
  }
  List<CategoryModel> categories = [];


  List colors = [0xff795548,0xffE91E63,0xff4FC3F7,0xff7F3217,0xff81D4FA,
  0xff8BC34A,0xffE99000,0xffF57F17,0xffF75F00];

  void getCategories(){
    emit(GetCategoriesLoadingState());
    DioHelper.getData(url: getCategoriesUrl,
    token: UserSession().token
    ).then((onValue){
      final List<dynamic> data = onValue.data;
      categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      emit(GetCategoriesSuccessState());
    }).catchError((onError){
      print(onError.response);
      emit(GetCategoriesErrorState());
    });
  }


  List<AdModel> ads = [];

  void getAds(){
    emit(GetAdsLoadingState());
    DioHelper.getData(url: "https://talabat.qada.digital/api/v1/advertisement/list",
    token: UserSession().token
    ).then((onValue){
      final List<dynamic> data = onValue.data;
      ads = data.map((e) => AdModel.fromJson(e)).toList();
      for(int i = 0 ; i < (ads.length>=4?4:ads.length) ;i++){
        sliderItems.add(Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(1.00, 0.50),
              end: Alignment(0.00, 0.50),
              colors: [const Color(0xB2F75F00), const Color(0xFFF75F00)],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child:ads[i].coverImageFullUrl!=null?
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(ads[i].coverImageFullUrl!,
            fit: BoxFit.fill,),
          ):null,
        ));
      }
      emit(GetAdsSuccessState());
    }).catchError((onError){
      print(onError);
      emit(GetAdsErrorState());
    });
  }

  /// Point in Polygon using ray-casting algorithm
  List<Zone> zones = [];

  /// Fetch zones from API
  void getZones() {
    emit(GetZonesLoadingState());
    DioHelper.getData(
      url: getZonesUrl,
      token: UserSession().token,
    ).then((onValue) {
      final List<dynamic> data = onValue.data;
      zones = data.map((z) => Zone.fromJson(z)).toList();

      if (zones.isNotEmpty) {
        getUserZone();
      }

      emit(GetZonesSuccessState());
    }).catchError((onError) {
      print("Error fetching zones: $onError");
      emit(GetZonesErrorState());
    });
  }

  /// Quick bounding-box filter
  bool isPointInBoundingBox(LatLng point, List<LatLng> polygon) {
    double minLat = polygon.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = polygon.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = polygon.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = polygon.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    return (point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLng &&
        point.longitude <= maxLng);
  }

  /// Point-in-polygon check
  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      LatLng p1 = polygon[j];
      LatLng p2 = polygon[j + 1];

      if (((p1.latitude > point.latitude) != (p2.latitude > point.latitude)) &&
          (point.longitude <
              (p2.longitude - p1.longitude) *
                  (point.latitude - p1.latitude) /
                  (p2.latitude - p1.latitude) +
                  p1.longitude)) {
        intersectCount++;
      }
    }
    return (intersectCount % 2 == 1); // odd = inside
  }

  /// Find the zone for a given user location
  Zone? findUserZone(double userLat, double userLng, List<Zone> zones) {
    LatLng userPoint = LatLng(userLat, userLng);

    for (final zone in zones) {
      if (isPointInBoundingBox(userPoint, zone.coordinates) &&
          isPointInPolygon(userPoint, zone.coordinates)) {
        return zone;
      }
    }
    return null; // not in any zone
  }

  LatLng? currentLocation;
  double? currentLat ;
  double? currentLng ;


  Future<void> setCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    while (true) {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Ask user to enable location service
        await Geolocator.openLocationSettings();
        continue; // re-check after returning
      }

      // Check & request location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Still denied → send to settings
          await Geolocator.openAppSettings();
          continue; // re-check when user comes back
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Must go to settings manually
        await Geolocator.openAppSettings();
        continue; // re-check after returning
      }

      // ✅ If we reach here, we have permission and service is on
      break;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLocation = LatLng(position.latitude, position.longitude);
    currentLat = currentLocation!.latitude;
    currentLng = currentLocation!.longitude;
    CacheHelper.putDate(key: "lat", data: currentLat);
    CacheHelper.putDate(key: "lng", data: currentLng);
    getAddress(currentLocation, "ar");
    if (currentLocation != null) {
      getZones();
    }
  }
  String address="";
  void setAddress(String ad){
    address = ad;
    emit(GetLocationSuccessState());
  }


  Future<void> getAddress(LatLng? location, String language) async {
    if (location == null) return;
    emit(GetLocationLoadingState());
    try {
      final response = await DioHelper.getData(
        url: "https://maps.googleapis.com/maps/api/geocode/json",
        queryParams: {
          "latlng": "${location.latitude},${location.longitude}",
          "key": "AIzaSyDSG1JvtmERikUhwGhdRupHGbYVHqEX_xA",
          "language": language,
        },
      );

      if (response.statusCode == 200 &&
          response.data['results'] != null &&
          response.data['results'].isNotEmpty) {
        print(response.data['results']);
        address = response.data['results'][0]['formatted_address'];
        CacheHelper.putDate(key: "address", data: address);
        emit(GetLocationSuccessState());
      } else {
        log("Geocoding API failed: ${response.statusCode} | ${response.data}");
        emit(GetLocationErrorState());
      }
    } catch (e, stack) {
      log("getAddress error: $e\n$stack");
      emit(GetLocationErrorState());
    }
  }
  /// Get user’s current zone
  void getUserZone() {
    // TODO: replace with real GPS from location package
    double userLat = 30.062980;
    double userLng = 31.345967;
    // double userLat = currentLocation!.latitude;
    // double userLng = currentLocation!.longitude;

    Zone? matchedZone = findUserZone(userLat, userLng, zones);

    if (matchedZone != null) {
      CacheHelper.putDate(key: "zoneId", data: matchedZone.id);
      UserSession().zoneId = matchedZone.id.toString();
      getAds();
      getPopularProducts();
      print("✅ User is inside zone: ${matchedZone.name}");
    } else {
      showToastMessage(message: "out_of_zone".tr(), color: Colors.red);
      print("❌ User is outside all zones");
    }
  }
  String? zoneId;


  void loadCachedZone()async {
     zoneId =( await CacheHelper.getData(key: "zoneId")).toString();
     address = await CacheHelper.getData(key: "address")??"";
     currentLat = await CacheHelper.getData(key: "lat");
     currentLng = await CacheHelper.getData(key: "lng");
     print(zoneId);
     print(address);
    if (zoneId != null) {
      print("📦 Loaded cached Zone ID: $zoneId");
    }
    if (address != "") {
      print("📦 Loaded cached Zone Address: $address");
    }

    if (zoneId != null && address != "" && currentLat != null && currentLng != null) {
      UserSession().zoneId = zoneId;
      getAds();
      getPopularProducts();
      emit(GetZonesSuccessState()); // emit state to rebuild UI if needed
      return;
    }
    else{
      setCurrentLocation();
    }
  }

  List<Product> popularProducts = [];

  void getPopularProducts() {
    emit(GetPopularProductsLoadingState());

    DioHelper.getData(
      url: getPopularProductsUrl,
      token: UserSession().token,
    ).then((response) {
      final model = PopularProducts.fromJson(response.data);

      popularProducts = model.products;
      print(popularProducts);

      emit(GetPopularProductsSuccessState());
    });
  }

}
