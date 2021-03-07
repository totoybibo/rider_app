import 'dart:collection';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
