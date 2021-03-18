import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppData extends ChangeNotifier {
  User _user;
  Address _origin;
  Address _destination;
  DirectionDetails _directionDetails;
  Address get origin => _origin;
  Address get destination => _destination;
  User get user => _user;
  String userName;
  String get userId => _user.uid;
  DirectionDetails get directionDetails => _directionDetails;
  set setDirectionDetails(DirectionDetails details) {
    _directionDetails = details;
    notifyListeners();
  }

  set setUser(User user) {
    _user = user;
    notifyListeners();
  }

  set setDestination(Address value) {
    _destination = value;
    notifyListeners();
  }

  set setOrigin(Address value) {
    _origin = value;
    notifyListeners();
  }

  String get calculateFare {
    double timeFare = (_directionDetails.durationValue / 60) * 0.2;
    double distanceFare = (_directionDetails.durationValue / 1000) * 0.2;
    double total = timeFare + distanceFare;
    return '\$${total.toStringAsFixed(2)}';
  }
}
