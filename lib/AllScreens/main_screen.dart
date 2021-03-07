import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/main_screen_drawer.dart';
import 'package:rider_app/AllWidgets/floating_drawer_button.dart';
import 'package:rider_app/AllWidgets/tab_buttons.dart';
import 'login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/constants.dart';
import 'dart:async';
import 'package:rider_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllWidgets/location_input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_app/AllWidgets/floating_loc_button.dart';
import 'package:rider_app/Helpers/helper_methods.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main';
  static final CameraPosition _kLocationPosition = kDefaultCameraPos;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //#region Variables
  Position currentPosition;
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
  String address;
  //#endregion

  //#region Methods

  void locationPosition(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    Address location = await HelperMethods.searchCoordinates(position, 'home');

    Provider.of<AppData>(context, listen: false).pickUpLocation = location;
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

  void addHome(BuildContext context) async {
    Address address =
        Provider.of<AppData>(context, listen: false).getPickupLocation;
    Fluttertoast.showToast(
        msg: '${address.address} to home successfully.',
        backgroundColor: kPrimaryColor,
        gravity: ToastGravity.TOP);
    Map dataMap = {
      'placeId': address.placeId,
      'name': address.name,
      'address': address.address,
      'latitude': address.latitude,
      'longitude': address.longitude
    };
    homeRef.child(user.uid).child(address.placeId).set(dataMap);
  }

  //#endregion

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newGoogleMapController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => isBSOpen = !visible);
      },
    );
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
              locationPosition(context);
            },
          ),
          FloatingDrawerButton(
            onTap: () => scaffoldKey.currentState.openDrawer(),
          ),
          FloatingLocButton(
            onTap: () => locationPosition(context),
          ),
          Positioned(
            height: isBSOpen ? MediaQuery.of(context).size.height / 2 : 100,
            bottom: 0,
            left: MediaQuery.of(context).viewInsets.left,
            right: MediaQuery.of(context).viewInsets.right,
            child: Container(
              decoration: BoxDecoration(
                color: kDarkModeColor,
              ),
              child: Column(
                children: [
                  LocationInput(
                    username: userDisplayName,
                    isBSOpen: isBSOpen,
                    address: '',
                    searchTap: () {},
                    textFormTap: () => setState(() => isBSOpen = true),
                    collapseTap: () => setState(() => isBSOpen = !isBSOpen),
                  ),
                  isBSOpen
                      ? TabButtons(
                          addFavorites: () {},
                          addHome: () => addHome(context),
                          addWork: () {})
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
