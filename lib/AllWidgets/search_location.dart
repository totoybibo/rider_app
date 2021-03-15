import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'dart:core';
import 'package:rider_app/Helpers/httprequest.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/AllWidgets/prediction_tile.dart';

class SearchLocation extends StatefulWidget {
  final String userId;
  final bool isBSOpen;
  final String currentLocation;
  final Function textFormTap;
  final Function placesTap;
  SearchLocation({
    @required this.userId,
    @required this.isBSOpen,
    @required this.currentLocation,
    @required this.textFormTap,
    @required this.placesTap,
  });

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  TextEditingController controller = TextEditingController();
  TextEditingController pickupController = TextEditingController();
  List<PlacePredictions> list = [];
  void findPlace(String value) async {
    if (controller.text.length > 2) {
      String urlAutoComplete =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${controller.text}&key=$googleMapKey&sessiontoken=123456789&components=country:SG';
      dynamic resp = await HTTPRequest.getRequest(urlAutoComplete);
      if (resp['status'] == 'OK') {
        dynamic predictions = resp['predictions'];
        dynamic placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() => list = placeList);
      }
    } else {
      setState(() => list = []);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favRef.child(widget.userId).onChildAdded.forEach((element) {
      String name = element.snapshot.value['name'];
      String key = element.snapshot.key;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentLocation);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kDarkModeColor,
        boxShadow: [kBoxShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                leading: GestureDetector(
                  onTap: () => Fluttertoast.showToast(
                      msg: 'Pick up location',
                      backgroundColor: Colors.lightBlueAccent,
                      gravity: ToastGravity.TOP),
                  child: Icon(Icons.location_pin,
                      size: 35, color: Colors.greenAccent),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Location',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    Text(
                      widget.currentLocation,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kDarkModeColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                leading: GestureDetector(
                  onDoubleTap: () => controller.clear(),
                  onTap: () => Fluttertoast.showToast(
                      msg: 'Your destination.',
                      backgroundColor: Colors.lightBlueAccent,
                      gravity: ToastGravity.TOP),
                  child: Icon(Icons.location_pin, size: 35, color: Colors.red),
                ),
                title: TextFormField(
                  maxLines: 1,
                  controller: controller,
                  style: TextStyle(
                      fontFamily: 'bolt-semibold',
                      fontWeight: FontWeight.bold,
                      color: kDarkModeColor,
                      fontSize: 16),
                  onChanged: (value) => findPlace(value),
                  onTap: widget.textFormTap,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration.copyWith(
                      labelText: 'Destination Location'),
                ),
              ),
            ),
            widget.isBSOpen
                ? Container(
                    height: 300,
                    child: ListView.separated(
                      itemCount: list.length,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => HDividerWidget(),
                      itemBuilder: (context, index) {
                        PlacePredictions place = list[index];
                        bool favorite = false;
                        return PredictionTile(
                            onFavePressed:
                                (PlacePredictions value, bool favorite) {
                              if (!favorite == true) {
                                Map faves = {'name': value.mainText};
                                favRef
                                    .child(widget.userId)
                                    .child(value.placeId)
                                    .set(faves);
                              } else {
                                favRef
                                    .child(widget.userId)
                                    .child(value.placeId)
                                    .remove();
                              }

                              return !favorite;
                            },
                            prediction: place,
                            onTap: (PlacePredictions value) {
                              controller.text = value.mainText;
                              widget.placesTap(value.placeId);
                            });
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
