import 'package:flutter/material.dart';
import 'package:rider_app/Helpers/httprequest.dart';
import 'package:rider_app/constants.dart';

class PlacePredictions {
  String mainText;
  String placeId;
  bool isFavorite = false;
  int index;
  PlacePredictions({this.mainText, this.placeId, this.isFavorite, this.index});
  PlacePredictions.fromJson(Map<String, dynamic> data) {
    mainText = data['description'];
    placeId = data['place_id'];
  }
}
