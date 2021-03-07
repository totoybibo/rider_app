import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacePredictions {
  String mainText;
  String placeId;
  PlacePredictions({this.mainText, this.placeId});
  PlacePredictions.fromJson(Map<String, dynamic> data) {
    mainText = data['description'];
    placeId = data['place_id'];
  }
}
