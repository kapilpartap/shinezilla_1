
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/booking/userSelectDate.dart';
import 'package:carwash/model/Helper/goggleKey.dart';
import 'package:carwash/model/locationapi/LocationConverter.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as loc;
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;

class LocationAccess extends StatefulWidget {
  const LocationAccess({super.key});
  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {
  Location location = Location();
  String? googleapikey;
  String? radiuskey;

  final Map<String, Marker> _markers = {};
  String selected_address = "N/A";
  Future<List<googleKey>>? goggle;
  double latitude = 0;
  double longitude = 0;
  GoogleMapController? _controller;
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(30.7333, 76.7794),
    zoom: 10,
  );

  Future<void> _handleSearch() async {
    places.Prediction? p = await loc.PlacesAutocomplete.show(
      context: context,
      apiKey: googleapikey!,
      onError: onError,
      mode: loc.Mode.fullscreen,
      language: 'en',
      strictbounds: false,
      types: [],
      decoration: InputDecoration(
        hintText: 'Search Place',
        border: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [],
    );

    if (p != null) {
      displayPrediction(p);
    }
  }

  void onError(places.PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<void> displayPrediction(places.Prediction p) async {
    places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
      apiKey: googleapikey!,
      apiHeaders: await const header.GoogleApiHeaders().getHeaders(),
    );
    places.PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
        p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    // Update the latitude and longitude
    latitude = lat;
    longitude = lng;

    _markers.clear();

    final marker = Marker(
      markerId: const MarkerId('searchLocation'),
      position: LatLng(lat, lng),
      draggable: true,
      infoWindow: const InfoWindow(
        title: 'Search Location',
      ),
      onDragEnd: (LatLng latLng) async {
        latitude = latLng.latitude;
        longitude = latLng.longitude;
        var textFromPlacemarks = await LocationConverter.getTextFromPlacemarks(
            latLng);
        setState(() {
          selected_address = textFromPlacemarks.toString();
        });
      },
    );

    setState(() {
      _markers['searchLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15),
        ),
      );
    });

    var textFromPlacemarks = await LocationConverter.getTextFromPlacemarks(
        LatLng(lat, lng));
    setState(() {
      selected_address = textFromPlacemarks.toString();
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentPosition = await location.getLocation();
    latitude = currentPosition.latitude!;
    longitude = currentPosition.longitude!;
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
      draggable: true,

      onDragEnd: (LatLng latLng) async {

        latitude = latLng.latitude;
        longitude = latLng.longitude;
        var textFromPlacemarks = await LocationConverter.getTextFromPlacemarks(
            latLng);
        setState(() {
          selected_address = textFromPlacemarks.toString();
        });
      },
      infoWindow: const InfoWindow(
        title: 'Selected Location',
      ),
    );
    setState(() {
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    goggle = fetchgoogleKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 30),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          label: Text(
            "Search",
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: _handleSearch,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: _markers.values.toSet(),
            onTap: (LatLng latlng) async {
              latitude = latlng.latitude;
              longitude = latlng.longitude;
              _markers.clear();
              final marker = Marker(
                markerId: const MarkerId('myLocation'),
                draggable: true,
                position: LatLng(latitude, longitude),
                infoWindow: const InfoWindow(
                  title: 'Your Location',
                ),
              );
              var textFromPlacemarks = await LocationConverter
                  .getTextFromPlacemarks(latlng);
              setState(() {
                _markers['myLocation'] = marker;
                selected_address = textFromPlacemarks.toString();
              });
            },
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 105),
          child: Card(
            child: ListTile(
              leading: Icon(
                Icons.location_on,
                color: ColorConverter.stringToHex(AppStrings.bg_color),
              ),
              title: selected_address != "N/A"
                  ? Text(selected_address)
                  : Text("Selected Location"),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 60),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
             if (selected_address != "N/A") {
               fetchRadiusFran();
             }
             else {
                 CustomWidget.showSnackbar(context, "Select Service Location!");
             }
              // if (selected_address != "N/A") {
              //   final routeargs = ModalRoute.of(context) ?.settings.arguments as Map;
              //   Navigator.pop(context);
              //   Navigator.pushNamed(context, "/UserSelectDate", arguments: {
              //     "id": routeargs["id"],
              //     "baddress": selected_address,
              //     "latitude": latitude,
              //     "longitude": longitude
              //   });
              // } else {
              //   CustomWidget.showSnackbar(context, "Select Service Location!");
              // }

            },
            child: Text(
              "Confirm Location",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }

  Future<List<googleKey>> fetchgoogleKey() async {
    String url = ApiStrings.base_url + ApiStrings.payKey;
    List<googleKey> googleService = [];
    var response = await http.post(Uri.parse(url), body: {
      'key_name': '2',
      "type": '1',
    });
    if (response.statusCode == 200) {
      var myapidata = jsonDecode(response.body);
      googleapikey = myapidata['api_key'];
    }
    return googleService;
  }


//Radius frannchise
  fetchRadiusFran() async {
    String url = ApiStrings.base_url + ApiStrings.radius_fran;
    var locresponse = await http.post(Uri.parse(url),
        body: {
          "latitude": latitude.toString(),
          "longitude": longitude.toString()
        });
    print(latitude);
    print(longitude);
    if (locresponse.statusCode == 200) {
      var locdata = jsonDecode(locresponse.body);
      print("Anu idiot");
         print(locdata["success"]);
      if (locdata["success"]==0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(locdata["message"])));
      }

      else {
        print("aaaaaa " + locdata["message"]);
        final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
        Navigator.pushNamed(context, '/UserSelectDate',
            arguments: {
              "franch_id": locdata["franch_id"].toString(),
              "id": routeargs["id"],
              "baddress": selected_address,
              "latitude": latitude,
              "longitude": longitude
            });
      }

      // = locdata['message'];
    }
  }
  }





// import 'dart:convert';
// import 'package:carwash/CustomWidget/ColorConverter.dart';
// import 'package:carwash/CustomWidget/CustomWidget.dart';
// import 'package:carwash/Model/api/ApiStrings.dart';
// import 'package:carwash/model/Helper/goggleKey.dart';
// import 'package:carwash/model/locationapi/LocationConverter.dart';
// import 'package:carwash/values/AppStrings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart' as loc;
// import 'package:google_api_headers/google_api_headers.dart' as header;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' as places;
// import 'package:location/location.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:http/http.dart' as http;
//
// class LocationAccess extends StatefulWidget {
//   const LocationAccess({super.key});
//   @override
//   State<LocationAccess> createState() => _LocationAccessState();
// }
//
// class _LocationAccessState extends State<LocationAccess> {
//   Location location = Location();
//   String? googleapikey;
//   final Map<String, Marker> _markers = {};
//   String selected_address = "N/A";
//   Future<List<googleKey>>? goggle;
//   double latitude = 0;
//   double longitude = 0;
//   GoogleMapController? _controller;
//   final CameraPosition _kGooglePlex = const CameraPosition(target: LatLng(30.7333, 76.7794),
//     zoom: 10,
//   );
//
//   Future<void> _handleSearch() async {
//     places.Prediction? p = await loc.PlacesAutocomplete.show(
//       context: context,
//       apiKey: googleapikey.toString(),
//       onError: onError, // call the onError function below
//       mode: loc.Mode.fullscreen,
//       language: 'en', //you can set any language for search
//       strictbounds: false,
//       types: [],
//       decoration: InputDecoration(
//           hintText: 'Search Place',
//           border: UnderlineInputBorder(
//             // borderRadius: BorderRadius.circular(20),
//               borderSide: const BorderSide(color: Colors.white))),
//       components: [], // you can determine search for just one country
//         //components: [Component(Component.country, "pk")]
//     );
//
//     var homeScaffoldKey;
//     displayPrediction(p!, homeScaffoldKey.currentState);
//   }
//
//   void onError(places.PlacesAutocompleteResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: 'Message',
//         message: response.errorMessage!,
//         contentType: ContentType.failure,
//       ),
//     ));
//   }
//
//   Future<void> displayPrediction(
//       places.Prediction p, ScaffoldState? currentState) async {
//     places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
//         apiKey: googleapikey,
//         apiHeaders: await const header.GoogleApiHeaders().getHeaders());
//     places.PlacesDetailsResponse detail =
//     await _places.getDetailsByPlaceId(p.placeId!);
//     // detail will get place details that user chose from Prediction search
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;
//     _markers.clear();
//     //clear old marker and set new one
//     final marker = Marker(
//       markerId: MarkerId('deliveryMarker'),
//       position: LatLng(lat, lng),
//       draggable: true,
//       infoWindow: const InfoWindow(
//         title: '',
//       ),
//     );
//     setState(() {
//       _markers['myLocation'] = marker;
//       _controller?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(lat, lng), zoom: 15),
//         ),
//       );
//     });
//   }
//
//   getCurrentLocation() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     LocationData currentPosition = await location.getLocation();
//     latitude = currentPosition.latitude!;
//     longitude = currentPosition.longitude!;
//     final marker = Marker(
//         markerId: const MarkerId('myLocation'),
//         position: LatLng(latitude, longitude),
//         draggable: true,
//         onDragEnd: (LatLng) async {
//           latitude = LatLng.latitude;
//           longitude = LatLng.longitude;
//           var textFromPlacemarks = await LocationConverter.getTextFromPlacemarks(LatLng);
//           print(textFromPlacemarks);
//           setState(() {
//             selected_address = textFromPlacemarks.toString();
//           });
//         },
//         infoWindow: const InfoWindow(
//           title: 'Selected Location',
//         ),
//         onTap: () => {print(latitude), print(longitude)});
//     setState(() {
//       _markers['myLocation'] = marker;
//       _controller?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
//         ),
//       );
//     });
//   }
//
//   @override
//   void initState() {
//     getCurrentLocation();
//     goggle = fetchgoogleKey();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton:Padding(
//         padding: EdgeInsets.only(top: 30),
//         child: FloatingActionButton.extended(
//         backgroundColor: Colors.black,
//         label: Text("Search",style: TextStyle(color: Colors.white),),
//         icon: Icon(Icons.search,color: Colors.white,),
//         onPressed: _handleSearch,
//       )),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//       body: Stack(children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           width: double.infinity,
//           height: double.infinity,
//           child: GoogleMap(
//             mapType: MapType.normal,
//             myLocationEnabled: true,
//             initialCameraPosition: _kGooglePlex,
//             markers: _markers.values.toSet(),
//             onTap: (LatLng latlng) async {
//               latitude = latlng.latitude;
//               longitude = latlng.longitude;
//               final marker = Marker(
//                 markerId: const MarkerId('myLocation'),
//                 draggable: true,
//                 position: LatLng(latitude, longitude),
//                 infoWindow: const InfoWindow(
//                   title: 'Your Location',
//                 ),
//               );
//               var textFromPlacemarks = await LocationConverter.getTextFromPlacemarks(latlng);
//                setState(() {
//                 _markers['myLocation'] = marker;
//                 selected_address = textFromPlacemarks.toString();
//               }
//              );
//             },
//             onMapCreated: (GoogleMapController controller) {
//               _controller = controller;
//             },
//           ),
//         ),
//         Container(
//             margin: EdgeInsets.only(left: 15, right: 15),
//             alignment: Alignment.bottomCenter,
//             padding: EdgeInsets.only(bottom: 105),
//             child: Card(
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.location_on,
//                     color: ColorConverter.stringToHex(AppStrings.bg_color),
//                   ),
//                   title: selected_address != null && selected_address != "N/A"
//                       ? Text(selected_address!)
//                       : Text("Selected Location"),
//                 ))),
//         Container(
//           alignment: Alignment.bottomCenter,
//           padding: EdgeInsets.only(bottom: 60),
//           child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//               onPressed: () {
//                 if (selected_address != null && selected_address != "N/A") {
//                   final routeargs =
//                   ModalRoute.of(context)?.settings.arguments as Map;
//                   print(routeargs["id"]);
//                   print(selected_address);
//                   Navigator.pushNamed(context, "/UserSelectDate", arguments: {
//                     "id": routeargs["id"],
//                     "baddress": selected_address,
//                     "latitude": latitude,
//                     "longitude": longitude
//                   });
//                 } else {
//                   CustomWidget.showSnackbar(
//                       context, "Select Service Location!");
//                 }
//               },
//               child: Text("Confirm Location",style: TextStyle(color: Colors.white),)),
//         )
//       ]),
//     );
//   }
//
//   //Future<List<Franchise>>
//   fetchFranchise(latitude, longitude) async {
//     String url = ApiStrings.api_host + ApiStrings.nearstFranchise;
//     // List<Franchise> franchise = [];
//     var response = await http.post(Uri.parse(url),
//         body: {"latitude": latitude, 'longitude': longitude});
//     print('helo' + response.body);
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       print(data);
//       print(response.statusCode);
//       Navigator.pushNamed(context, '/UserSelectDate');
//     } else {
//       print("something went wrong ");
//     }
//   }
//
//   Future<List<googleKey>> fetchgoogleKey() async {
//     String url = ApiStrings.base_url + ApiStrings.payKey;
//     print("url " + url);
//     List<googleKey> googleService = [];
//     var response = await http.post(Uri.parse(url),
//         body: {
//           'key_name': '2',
//           "type": '1'
//         }
//     );
//     if (response.statusCode == 200) {
//       var myapidata = jsonDecode(response.body);
//       googleapikey = myapidata['api_key'];
//     }
//     return googleService;
//   }
// }
//
//
//
//
//
//
