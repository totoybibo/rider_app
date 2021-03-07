import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kDarkModeColor = Color(0xFF303030);
const kPrimaryColor = Color(0xFFeeaa46);
const kBoxConstraints = BoxConstraints.tightFor(width: double.infinity);
const kWorkListItem = ListTile(
  subtitle: Text('Work/Office address', style: TextStyle(color: Colors.grey)),
  leading: Icon(FontAwesomeIcons.suitcase, size: 35, color: Color(0xFFeeaa46)),
  title: Text('Add Work',
      style: TextStyle(
          color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
);
const kHomeListItem = ListTile(
  subtitle: Text('Living home address', style: TextStyle(color: Colors.grey)),
  leading: Icon(FontAwesomeIcons.home, size: 35, color: Color(0xFFeeaa46)),
  title: Text('Add Home',
      style: TextStyle(
          color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
);
const kFavoriteListItem = ListTile(
  subtitle: Text('Favorite address list', style: TextStyle(color: Colors.grey)),
  leading: Icon(FontAwesomeIcons.solidStar, size: 35, color: Color(0xFFeeaa46)),
  title: Text('Add Favorites',
      style: TextStyle(
          color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
);
const kInputDecoration = InputDecoration(
    border: InputBorder.none,
    hintText: 'Where to?',
    hintStyle: TextStyle(
        fontFamily: 'bolt-semibold',
        color: Colors.green,
        fontSize: 20,
        fontWeight: FontWeight.bold));
const kDefaultCameraPos = CameraPosition(
  // target: LatLng(1.3091294601034407, 103.7944606046135),
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
//const kLatLng = LatLng(37.42796133580664, -122.085749655962); //Google Headquarters
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
