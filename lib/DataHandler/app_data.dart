import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/location_model.dart';

class AppData extends ChangeNotifier {
  Address _origin;
  Address _destination;
  Address get origin => _origin;
  Address get destination => _destination;
  set setDestination(Address value) {
    _destination = value;
    notifyListeners();
  }

  set setOrigin(Address value) {
    _origin = value;
    notifyListeners();
  }
}
