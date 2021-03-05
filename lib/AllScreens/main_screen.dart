import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/main_screen_drawer.dart';
import 'package:rider_app/AllWidgets/floating_drawer_button.dart';
import 'login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/constants.dart';
import 'dart:async';
import 'package:rider_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllWidgets/location_input.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main';
  static final CameraPosition _kLocationPosition = kHollandVillage;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();
  Completer<GoogleMapController> gMapController = Completer();
  GoogleMapController newGoogleMapController;
  String userDisplayName;
  bool isBSOpen = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey bottomSheetBtn = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newGoogleMapController.dispose();
  }

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
      key: scaffoldKey,
      drawer: MainScreenDrawer(
        username: userDisplayName,
        user: user,
        signOut: () {
          Fluttertoast.showToast(
              msg: 'Goodbye $userDisplayName',
              backgroundColor: Colors.lightBlueAccent,
              gravity: ToastGravity.TOP);
          _auth.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.id, (route) => false);
        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: MainScreen._kLocationPosition,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              gMapController.complete(controller);
              newGoogleMapController = controller;
            },
          ),
          FloatingDrawerButton(
            onTap: () => scaffoldKey.currentState.openDrawer(),
          ),
          Positioned(
            key: bottomSheetKey,
            height: isBSOpen ? MediaQuery.of(context).size.height / 2 : 100,
            bottom: 0,
            left: MediaQuery.of(context).viewInsets.left,
            right: MediaQuery.of(context).viewInsets.right,
            child: LocationInput(
              username: userDisplayName,
              isBSOpen: isBSOpen,
              searchTap: () {},
              textFormTap: () => setState(() => isBSOpen = true),
              collapseTap: () => setState(() => isBSOpen = !isBSOpen),
              addHome: () => setState(() {}),
              addWork: () => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}
