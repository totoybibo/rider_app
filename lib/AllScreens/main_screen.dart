import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/main_screen_drawer.dart';
import 'package:rider_app/AllWidgets/floating_buttons.dart';
import 'login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/constants.dart';
import 'dart:async';
import 'package:rider_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllWidgets/search_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_app/Helpers/helper_methods.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rider_app/Helpers/httprequest.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main';
  static final CameraPosition _kLocationPosition = kDefaultCameraPos;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //#region Variables
  Position currentPosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();
  Completer<GoogleMapController> gMapController = Completer();
  GoogleMapController newGoogleMapController;
  String userDisplayName;
  bool isBSOpen = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> bottomKey = GlobalKey<ScaffoldState>();
  Address currentLocation;
  String currentPickUpLocation = '';
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
    currentLocation = location;
    setState(() => currentPickUpLocation = currentLocation.address);
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

  void destinationPosition(String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleMapKey';
    dynamic resp = await HTTPRequest.getRequest(url);
    if (resp['status'] == 'OK') {
      double lat = resp['result']['geometry']['location']['lat'];
      double lng = resp['result']['geometry']['location']['lng'];
      LatLng latLngPosition = LatLng(lat, lng);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() => isBSOpen = false);
    }
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
          DrawerButton(
            onTap: () => scaffoldKey.currentState.openDrawer(),
          ),
          HomeButton(
            onTap: () => locationPosition(context),
          ),
          ToggleButton(
            onTap: () => setState(() => isBSOpen = !isBSOpen),
            isBSOpen: isBSOpen,
          ),
          Positioned(
            key: bottomKey,
            height: isBSOpen ? MediaQuery.of(context).size.height / 1.8 : 170,
            bottom: 0,
            left: MediaQuery.of(context).viewInsets.left,
            right: MediaQuery.of(context).viewInsets.right,
            child: Container(
              decoration: BoxDecoration(
                color: kDarkModeColor,
              ),
              child: SearchLocation(
                username: userDisplayName,
                isBSOpen: isBSOpen,
                currentLocation: currentPickUpLocation,
                textFormTap: () => setState(() => isBSOpen = true),
                placesTap: (value) => destinationPosition(value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
