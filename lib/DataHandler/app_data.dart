import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:geolocator/geolocator.dart';

class AppData extends ChangeNotifier {
  Address _pickupLocation;
  Address _destinationLocation;
  Address get pickupLocation => _pickupLocation;
  Address get pickUpPosition => _pickupLocation;
  Address get destinationPosition => _destinationLocation;
  set destinationLocation(Address value) {
    _destinationLocation = value;
    notifyListeners();
  }

  set pickUpLocation(Address value) {
    _pickupLocation = value;
    notifyListeners();
  }
}
