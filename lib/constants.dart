import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String googleMapKey = 'AIzaSyA_35szt8lTca-sbzbp8wx9LTk72MU0S48';
const kBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(20), topRight: Radius.circular(20));
const kBoxShadow = BoxShadow(
    color: Colors.black,
    blurRadius: 16,
    spreadRadius: 0.5,
    offset: Offset(0.7, 0.7));
const kInfoIcon =
    Icon(FontAwesomeIcons.infoCircle, color: Colors.lightBlueAccent);
const kLoginInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    fontSize: 20,
    color: Colors.grey,
  ),
);
