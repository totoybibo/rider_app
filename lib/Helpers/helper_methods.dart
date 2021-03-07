import 'package:geolocator/geolocator.dart';
import 'httprequest.dart';
import 'package:rider_app/Models/location_model.dart';

class HelperMethods {
  static Future<Address> searchCoordinates(
      Position position, String name) async {
    String st1, st2, st3, st4;
    String address = '';
    String placeId = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyA_35szt8lTca-sbzbp8wx9LTk72MU0S48';
    dynamic response = await HTTPRequest.getRequest(url);
    if (response == 'nodata') {
      address = 'Address Unknown';
    } else {
      address = response['results'][0]['formatted_address'];
      placeId = response['results'][0]['place_id'];
    }
    return Address(
        placeId: placeId, name: name, address: address, position: position);
  }
}
