import 'dart:collection';
import 'package:geolocator/geolocator.dart';

class DirectionDetails {
  int distanceValue;
  int durationValue;
  String distanceText;
  String durationText;
  String encodedPoints;
  DirectionDetails(
      {this.distanceValue,
      this.durationText,
      this.distanceText,
      this.durationValue,
      this.encodedPoints});
}

class Address {
  final String placeId;
  final String name;
  final String address;
  final Position position;
  Address({this.placeId, this.name, this.address, this.position});
  Position get getPosition => position;
  double get latitude => position.latitude;
  double get longitude => position.longitude;
}

class AddressList {
  UnmodifiableListView<Address> locations;

  Address getLocationByIndex(int index) => locations.elementAt(index);

  Address getLocationByName(String name) {
    Address loc;
    locations.forEach((element) {
      if (element.name == name) loc = element;
    });
    return loc;
  }
}
