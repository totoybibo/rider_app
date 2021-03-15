import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacePredictions {
  String mainText;
  String placeId;
  bool isFavorite = false;
  PlacePredictions({this.mainText, this.placeId, this.isFavorite});
  PlacePredictions.fromJson(Map<String, dynamic> data) {
    mainText = data['description'];
    placeId = data['place_id'];
  }
}
