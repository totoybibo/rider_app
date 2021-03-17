import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/Helpers/httprequest.dart';
import 'package:rider_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rider_app/AllWidgets/placelist_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class DestinationScreen extends StatefulWidget {
  static const id = 'destination';

  final Function onTap;
  DestinationScreen({@required this.onTap});
  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  bool showSpinner = false;
  List<PlacePredictions> list = [];
  List<PlacePredictions> faveList = [];
  TextEditingController controller = TextEditingController();
  bool isFavorites = true;
  final User user = FirebaseAuth.instance.currentUser;
  String userDisplayName = '';
  PlacePredictions selectedPlace;
  int keyBoardHeight = 2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getFavorites();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) => keyBoardHeight = visible ? 4 : 2,
    );
  }

  void getFavorites() async {
    await favRef.child(user.uid).onChildAdded.forEach((element) {
      PlacePredictions place = PlacePredictions(
          mainText: element.snapshot.value['name'],
          placeId: element.snapshot.key,
          isFavorite: true);
      setState(() => faveList.add(place));
    });
  }

  void findPlaces(String value) async {
    List<PlacePredictions> _list = [];
    if (controller.text.length > 4) {
      String urlAutoComplete =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${controller.text}&key=$googleMapKey&sessiontoken=123456789&components=country:SG';
      dynamic resp = await HTTPRequest.getRequest(urlAutoComplete);
      if (resp['status'] == 'OK') {
        dynamic predictions = resp['predictions'];
        dynamic placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        _list = placeList;
      }
    }
    setState(() {
      list = _list;
      isFavorites = !_list.isNotEmpty;
    });
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
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: kDarkModeColor,
        leading: RawMaterialButton(
          onPressed: () => Navigator.pop(context),
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
              'Where to, ${userDisplayName ?? ''}?',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.location_city_outlined,
              color: Colors.blueGrey,
              size: 40,
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  findPlaces(value);
                },
                maxLines: 2,
                autocorrect: false,
                enableSuggestions: false,
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: RawMaterialButton(
                    onPressed: () {
                      controller.clear();
                      setState(() => list = faveList);
                    },
                    shape: CircleBorder(),
                    constraints: BoxConstraints.tightFor(width: 10, height: 10),
                    child: Icon(
                      Icons.clear,
                      size: 30,
                      color: Colors.blueGrey,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Where to?',
                  labelStyle: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                height: MediaQuery.of(context).size.height / keyBoardHeight,
                child: PlaceListTab(
                  userId: user.uid,
                  onTap: (PlacePredictions value) {
                    controller.text = value.mainText;
                    selectedPlace = value;
                  },
                  list: list.isNotEmpty ? list : faveList,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: RawMaterialButton(
                  highlightColor: Colors.lightBlueAccent,
                  fillColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.pop(context, selectedPlace);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Confirm Destination',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Icon(FontAwesomeIcons.locationArrow, color: Colors.white)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
