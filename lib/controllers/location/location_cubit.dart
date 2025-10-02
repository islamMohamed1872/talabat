import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/controllers/location/location_states.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/network/dio_helper.dart';

class LocationCubit extends Cubit<LocationStates>{
  LocationCubit() : super(LocationInitialState());
  static LocationCubit get(context) => BlocProvider.of(context);

  GoogleMapController? mapController;
  LatLng? selectedLocation;
  LatLng? currentLocation;
  String selectedAddress = "";
  final locationController = TextEditingController();
  final searchController = TextEditingController();

  Future<void> setCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Set to selectedLocation
    // selectedLocation = LatLng(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude, position.longitude);
    moveCameraToSelectedLocation();

  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void setSelectedLocation(LatLng latLng) {
    selectedLocation = latLng;
    locationController.text = '${latLng.latitude}, ${latLng.longitude}';
    emit(SetSelectedLocationState());
  }
  void moveCameraToSelectedLocation() {
    if (currentLocation != null&&mapController!=null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation!, 14.5),
      );
    }
    emit(SetSelectedLocationState());
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
        selectedAddress = response.data['results'][0]['formatted_address'];
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
  void setSelectedAddress(String address){
    selectedAddress =  address;
    emit(SetSelectedAddressState());
  }
}