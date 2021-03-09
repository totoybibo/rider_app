import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rider_app/AllWidgets/main_screen_drawer.dart';
import 'package:rider_app/AllWidgets/floating_buttons.dart';
import 'package:rider_app/PolylinePoints/flutter_polyline_points.dart';
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
  Address destinationLocation;
  String currentPickUpLocation = '';
  bool showSpinner = false;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Geolocator geolocator = Geolocator();
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
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
        Provider.of<AppData>(context, listen: false).pickupLocation;
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

  void homePosition() async {
    LatLng homeLatLng = LatLng(1.3091294601034407, 103.7944606046135);
    CameraPosition cameraPosition =
        CameraPosition(target: homeLatLng, zoom: 14.4746);
    await newGoogleMapController
        .animateCamera(CameraUpdate.newLatLng(homeLatLng));
  }

  void destinationPosition(BuildContext context, String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleMapKey';
    dynamic resp = await HTTPRequest.getRequest(url);
    if (resp['status'] == 'OK') {
      double lat = resp['result']['geometry']['location']['lat'];
      double lng = resp['result']['geometry']['location']['lng'];
      LatLng latLngPosition = LatLng(lat, lng);
      Position position = Position(
          latitude: latLngPosition.latitude,
          longitude: latLngPosition.longitude);

      Address destination =
          Address(placeId: placeId, name: 'destination', position: position);
      Provider.of<AppData>(context, listen: false).destinationLocation =
          destination;

      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14.4746);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      getPlaceDirection();
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
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
              zoomControlsEnabled: true,
              markers: markerSet,
              circles: circleSet,
              polylines: polyLineSet,
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
              onTap: () => homePosition(),
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
                  placesTap: (value) {
                    destinationPosition(context, value);
                    setState(()=> isBSOpen=false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    setState(() => showSpinner = true);
    try {
      Address initialPosition =
          Provider.of<AppData>(context, listen: false).pickUpPosition;
      Address destinationPosition =
          Provider.of<AppData>(context, listen: false).destinationPosition;
      LatLng pickUpLatLng =
          LatLng(initialPosition.latitude, initialPosition.longitude);
      LatLng destinationLatLng =
          LatLng(destinationPosition.latitude, destinationPosition.longitude);
      DirectionDetails details = await HelperMethods.getDirectionDetails(
          pickUpLatLng, destinationLatLng);

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedPolylinePointsResult =
          polylinePoints.decodePolyline(details.encodedPoints);
      pLineCoordinates.clear();
      if (decodedPolylinePointsResult.isNotEmpty) {
        decodedPolylinePointsResult.forEach((element) {
          pLineCoordinates.add(
            LatLng(element.latitude, element.longitude),
          );
        });
      }
      polyLineSet.clear();
      setState(() {
        Polyline polyLine = Polyline(
            polylineId: PolylineId('PolylineID'),
            color: Colors.blueAccent,
            jointType: JointType.round,
            points: pLineCoordinates,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            geodesic: true);
        polyLineSet.add(polyLine);
      });
      LatLngBounds latLngBounds;
      if (pickUpLatLng.latitude > destinationLatLng.latitude &&
          pickUpLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds =
            LatLngBounds(southwest: destinationLatLng, northeast: pickUpLatLng);
      } else if (pickUpLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
        );
      } else if (pickUpLatLng.latitude > destinationLatLng.latitude) {
        latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
        );
      } else {
        latLngBounds =
            LatLngBounds(southwest: pickUpLatLng, northeast: destinationLatLng);
      }
      newGoogleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      Marker pickupMarker = Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
              title: initialPosition.name, snippet: 'Current Location'),
          position: pickUpLatLng,
          markerId: MarkerId(initialPosition.placeId));

      Marker destinationMarker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: destinationPosition.name, snippet: 'Destination Location'),
          position: destinationLatLng,
          markerId: MarkerId(destinationPosition.placeId));

      setState(() {
        markerSet.add(pickupMarker);
        markerSet.add(destinationMarker);
      });

      Circle pickupCircle = Circle(
          fillColor: kPrimaryColor,
          center: pickUpLatLng,
          radius: 12,
          strokeWidth: 4,
          strokeColor: Colors.yellowAccent,
          circleId: CircleId(initialPosition.placeId));

      Circle destinationCircle = Circle(
          fillColor: Colors.red,
          center: destinationLatLng,
          radius: 12,
          strokeWidth: 4,
          strokeColor: Colors.redAccent,
          circleId: CircleId(destinationPosition.placeId));

      setState(() {
        circleSet.add(pickupCircle);
        circleSet.add(destinationCircle);
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() => showSpinner = false);
    }
  }
}
