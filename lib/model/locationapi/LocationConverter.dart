
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationConverter
{

  static  getAddressFromLatLng(latitude,longitude) async {

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      return placemarks;
  }
  static Future<String?> getTextFromPlacemarks(LatLng ltlg) async {
    List<Placemark> placemarks= await getAddressFromLatLng(ltlg.latitude, ltlg.longitude);
    Placemark place= placemarks[0];
    StringBuffer buffer = new StringBuffer();
     buffer.write(place.subLocality! + ", " );
     buffer.write(place.locality ! + ", " );
     buffer.write(place.administrativeArea! + ", " );
     buffer.write(place.postalCode! + ", " );
     // buffer.write(place.name);
    //buffer.write(place.street);
   // buffer.write(place.subAdministrativeArea);
  // buffer.write(place.isoCountryCode);

    return buffer.toString();
  }



}



