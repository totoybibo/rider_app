import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rider_app/AllScreens/destination_screen.dart';
import 'package:rider_app/AllScreens/login_screen.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/constants.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:rider_app/PolylinePoints/flutter_polyline_points.dart';
import 'package:rider_app/Helpers/helper_methods.dart';
import 'package:rider_app/Helpers/httprequest.dart';
import 'package:rider_app/main.dart';
import 'confirm_screen.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main';
  static final CameraPosition _kLocationPosition = kDefaultCameraPos;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> gMapController = Completer();
  GoogleMapController newGoogleMapController;
  bool showSpinner = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final User user = FirebaseAuth.instance.currentUser;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Geolocator geolocator = Geolocator();
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Function onTap;
  Address currentLocation;
  Address destinationLocation;
  String currentPickUpLocation = '';
  String destination = '';
  Position currentPosition;

  bool showBooking = false;
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
    Provider.of<AppData>(context, listen: false).setOrigin = location;
    currentLocation = location;
    setState(() {
      currentPickUpLocation = currentLocation.address;
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User usr = Provider.of<AppData>(context, listen: false).user;
    String userName = Provider.of<AppData>(context, listen: false).userName;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: kDarkModeColor,
        leading: RawMaterialButton(
          onPressed: () => Navigator.popAndPushNamed(context, LoginScreen.id),
          shape: CircleBorder(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey,
            size: 30,
          ),
        ),
        title: Container(
          child: ListTile(
            title: Text(
              '$userName!',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Lets book a ride',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: Image.asset('images/user_icon.png'),
          ),
        ),
      ),
      backgroundColor: kDarkModeColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: RawMaterialButton(
                        highlightColor: Colors.blueAccent,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: ListTile(
                          title: Text('origin'),
                          subtitle: Text(
                            currentPickUpLocation,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green),
                          ),
                          trailing: Icon(Icons.my_location,
                              size: 50, color: Colors.green),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: RawMaterialButton(
                        highlightColor: Colors.blueAccent,
                        onPressed: () async {
                          setState(() => showSpinner = true);
                          try {
                            dynamic dest = await Navigator.pushNamed<dynamic>(
                                context, DestinationScreen.id);
                            if (dest == null) return;
                            PlacePredictions place = dest;
                            await destinationPosition(context, place);
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() => showSpinner = false);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: ListTile(
                          title: Text('destination'),
                          subtitle: Text(
                            destination ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: kPrimaryColor),
                          ),
                          trailing: Icon(
                            Icons.location_pin,
                            size: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: GoogleMap(
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
                ),
                SizedBox(height: 8),
                Container(
                  height: 50,
                  child: RawMaterialButton(
                    highlightColor: Colors.lightBlueAccent,
                    fillColor: Colors.blueGrey,
                    onPressed: () {
                      if (destination.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please select destination',
                            backgroundColor: Colors.blueAccent,
                            gravity: ToastGravity.CENTER);
                      } else {
                        Navigator.pushNamed(context, ConfirmScreen.id);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(FontAwesomeIcons.check, color: Colors.white),
                        Text('Confirm',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Icon(FontAwesomeIcons.taxi, color: Colors.white)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newGoogleMapController.dispose();
  }

  Future<void> destinationPosition(
      BuildContext context, PlacePredictions place) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${place.placeId}&fields=geometry&key=$googleMapKey';
    dynamic resp = await HTTPRequest.getRequest(url);
    print(resp['result']);
    if (resp['status'] == 'OK') {
      double lat = resp['result']['geometry']['location']['lat'];
      double lng = resp['result']['geometry']['location']['lng'];
      LatLng latLngPosition = LatLng(lat, lng);
      Position position = Position(
          latitude: latLngPosition.latitude,
          longitude: latLngPosition.longitude);

      Address address =
          await HelperMethods.searchCoordinates(position, 'destination');
      setState(() => destination = place.mainText);
      Provider.of<AppData>(context, listen: false).setDestination = address;

      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14.4746);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      getPlaceDirection();
    }
  }

  Future<void> getPlaceDirection() async {
    setState(() => showSpinner = true);
    try {
      Address initialPosition =
          Provider.of<AppData>(context, listen: false).origin;
      Address destinationPosition =
          Provider.of<AppData>(context, listen: false).destination;
      LatLng pickUpLatLng =
          LatLng(initialPosition.latitude, initialPosition.longitude);
      LatLng destinationLatLng =
          LatLng(destinationPosition.latitude, destinationPosition.longitude);
      DirectionDetails details = await HelperMethods.getDirectionDetails(
          pickUpLatLng, destinationLatLng);

      Provider.of<AppData>(context, listen: false).setDirectionDetails =
          details;

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
              title: initialPosition.name, snippet: initialPosition.address),
          position: pickUpLatLng,
          markerId: MarkerId(initialPosition.placeId));

      Marker destinationMarker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: destinationPosition.name,
              snippet: destinationPosition.address),
          position: destinationLatLng,
          markerId: MarkerId(destinationPosition.placeId));
      markerSet.clear();
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
      circleSet.clear();
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
