import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/config.dart';
import 'package:rider_app/constants.dart';
import 'dart:async';
import 'package:rider_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main';
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser;
  Completer<GoogleMapController> gMapController = Completer();
  GoogleMapController newGoogleMapController;
  String userDisplayName;

  void getUser() async {
    if (user != null) {
      await userRef.child(user.uid).once().then((snap) {
        if (snap != null) {
          setState(() => userDisplayName = snap.value['name']);
        } else {
          Fluttertoast.showToast(
              msg: 'No record found for ${user.email}',
              backgroundColor: Colors.lightBlueAccent);
          _auth.signOut();
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: RawMaterialButton(
          onPressed: () {
            setState(() {});
          },
          constraints: BoxConstraints.tightFor(width: 80, height: 80),
          shape: CircleBorder(),
          elevation: 10,
          fillColor: Colors.grey.shade700,
          highlightColor: Colors.blueAccent,
          child: Icon(
            FontAwesomeIcons.search,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: Text('Main Screen'),
      // ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: MainScreen._kGooglePlex,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              gMapController.complete(controller);
              newGoogleMapController = controller;
            },
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Container(
          //     height: 320,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: kBorderRadius,
          //       boxShadow: [kBoxShadow],
          //     ),
          //     child: Padding(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          //       child: Column(
          //         children: [
          //           SizedBox(height: 10),
          //           Text('Hi there, $userDisplayName',
          //               style:
          //                   TextStyle(fontSize: 18, color: Colors.blueAccent)),
          //           Text('Where to?',
          //               style: TextStyle(
          //                   fontSize: 24,
          //                   fontFamily: 'bolt-semibold',
          //                   color: Colors.blueAccent)),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
