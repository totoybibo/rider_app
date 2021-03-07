import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/location_model.dart';

class AppData extends ChangeNotifier {
  Address _pickupLocation;

  Address get getPickupLocation => _pickupLocation;

  set pickUpLocation(Address value) {
    _pickupLocation = value;
    notifyListeners();
  }
}
