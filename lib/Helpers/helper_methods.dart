import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'httprequest.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:rider_app/constants.dart';

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

  static Future<DirectionDetails> getDirectionDetails(
      LatLng pickUp, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleMapKey';
    dynamic res = await HTTPRequest.getRequest(url);
    if (res['status'] != 'OK') {
      return DirectionDetails();
    }

    DirectionDetails direction = DirectionDetails();
    direction.encodedPoints = res['routes'][0]['overview_polyline']['points'];
    direction.distanceText = res['routes'][0]['legs'][0]['distance']['text'];
    direction.distanceValue = res['routes'][0]['legs'][0]['distance']['value'];
    direction.durationText = res['routes'][0]['legs'][0]['duration']['text'];
    direction.durationValue = res['routes'][0]['legs'][0]['duration']['value'];

    return direction;
  }
}
