import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/models/user_session_singleton.dart';
import 'package:foodapp/controllers/home/home_cubit.dart';
import 'package:foodapp/controllers/location/location_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../services/storage/cache_helper.dart';
import '../../controllers/location/location_states.dart';
import '../widgets/const.dart';
import '../widgets/primary_button.dart';

class ChooseLocationScreen extends StatelessWidget {
  const ChooseLocationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LocationCubit(),
        child: BlocBuilder<LocationCubit,LocationStates>(
          builder: (context, state) {
            LocationCubit cubit = LocationCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target:
                          // LatLng(37.7749, -122.4194),
                          cubit.currentLocation??LatLng(30.0444, 31.2357),
                          zoom: 14.5,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) async{
                          cubit.setMapController(controller);
                          // optional
                          await cubit.setCurrentLocation();

                        },
                        onCameraMove: (p) {
                          print(p.target.latitude);
                          CacheHelper.putDate(key: "lat",data:  p.target.latitude);
                          CacheHelper.putDate(key: "lng",data:  p.target.longitude);
                          cubit.selectedLocation = LatLng(p.target.latitude, p.target.longitude);
                        },
                        onCameraIdle: () async {
                          cubit.getAddress(cubit.selectedLocation,context.locale.languageCode);
                        },
                        // polylines: cubit.polylines,
                        // onTap: (LatLng latLng) async{
                        //   cubit.setSelectedLocation(latLng);
                        //
                        //   final points = await cubit.fetchRoutePolyline(
                        //     origin: LatLng(cubit.currentLocation!.latitude, cubit.currentLocation!.longitude),
                        //     destination: LatLng(cubit.selectedLocation!.latitude, cubit.selectedLocation!.longitude),
                        //     apiKey: 'AIzaSyB0OIdBuWUM-2nq_R04rZqvwPZ5k0gqypw',
                        //   );
                        //
                        //   cubit.drawPolyline(points);
                        //   if (points.isNotEmpty) {
                        //     cubit.mapController!.animateCamera(
                        //       CameraUpdate.newLatLngBounds(
                        //         cubit.boundsFromLatLngList(points),
                        //         50.0, // Padding
                        //       ),
                        //     );
                        //   }
                        // },
                        // markers: cubit.selectedLocation != null
                        //     ? {
                        //   Marker(
                        //     markerId: MarkerId('selected'),
                        //     position: cubit.selectedLocation!,
                        //   ),
                        // }
                        //     : {},
                      ),
                      Positioned(
                        bottom: 80.h,
                        right: 20.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 21,
                          child: IconButton(onPressed: () {
                            cubit.mapController!.animateCamera(
                              CameraUpdate.newLatLngZoom(cubit.currentLocation!, 14.5),
                            );
                          },
                              icon: Icon(Icons.my_location,
                                color: Colors.black,
                                size: 25.w,
                              )
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50.h,
                        left: 20.w,
                        right: 20.w,
                        child: Row(
                          children: [
                            // Expanded is fine here because Row is constrained by Positioned (left + right)
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: TextField(
                                  onTap: ()async {
                                    var result = await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (c, a1, a2) => SearchPage(
                                          language: context.locale.languageCode,
                                                  apiKey: "AIzaSyDSG1JvtmERikUhwGhdRupHGbYVHqEX_xA",
                                                  searchPlaceHolder: "search_address".tr()
                                        ),
                                      ),
                                    );
                                    if (result != null) {
                                      final location = await getPlace(result,"AIzaSyDSG1JvtmERikUhwGhdRupHGbYVHqEX_xA",context.locale.languageCode); // pass only the place_id
                                      CacheHelper.putDate(key: "lat", data: double.parse(location['lat'].toString()));
                                      CacheHelper.putDate(key: "lng", data: double.parse(location['lng'].toString()));
                                      CameraPosition cPosition = CameraPosition(
                                        zoom: 15,
                                        target: LatLng(
                                          double.parse(location['lat'].toString()),
                                          double.parse(location['lng'].toString()),
                                        ),
                                      );
                                      final GoogleMapController controller =  cubit.mapController!;
                                      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
                                    }
                                  },
                                  controller: cubit.searchController,
                                  textAlign: TextAlign.right, // good for Arabic
                                  decoration: InputDecoration(
                                    hintText: "search_address".tr(),
                                    hintStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: "madReg",
                                      color: const Color(0xff6F6F6F),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20.r,
                                child: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 20,),
                              ),
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Icon(Icons.location_on,color: Color(mainColor),size: 30.w,),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 22.70,
                        offset: Offset(0, -2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on,color: Color(mainColor),size: 20.w,),
                          SizedBox(width: 10.w,),
                          Expanded(child: text12Style(text: cubit.selectedAddress))
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(text: "confirm_address".tr(), onPressed: (){
                          HomeCubit.get(context).setAddress(cubit.selectedAddress);
                          CacheHelper.putDate(key: "address", data: cubit.selectedAddress);
                          Navigator.pop(context);
                        },height: 35.h,),
                      )
                    ],
                  ),
                )
              ],
            );
          },),
      ),
    );
  }
  Future<Map<String, dynamic>> getPlace(String placeId,String key , String language) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseURL?place_id=$placeId&key=${key}&language=${language}';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final res = json.decode(response.body);

      if (res['status'] == 'OK' && res['result'] != null) {
        final location = res['result']['geometry']['location'];
        print("Lat: ${location['lat']}, Lng: ${location['lng']}");
        return Map<String, dynamic>.from(location);
      } else {
        throw Exception("Google API error: ${res['status']} - ${res['error_message'] ?? 'No details'}");
      }
    } else {
      throw Exception('Failed to load place details (code ${response.statusCode})');
    }
  }

}

class SearchPage extends StatefulWidget {
  final String language;
  final String apiKey;
  final String searchPlaceHolder;
  const SearchPage({
    Key? key,
    required this.language,
    required this.apiKey,
    required this.searchPlaceHolder,
  }) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  var _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = UserSession().token;
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=${widget.apiKey}&sessiontoken=$_sessionToken&language=en';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: null,
              hintText: "address".tr(),
              hintStyle: const TextStyle(fontSize: 12),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : InkWell(
                onTap: () => _controller.clear(),
                child: const Icon(Icons.clear),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _placeList.length,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () {

              // print(_placeList[i]);
              Navigator.pop(context, _placeList[i]["place_id"]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.location_pin,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Text(
                          _placeList[i]["description"],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
