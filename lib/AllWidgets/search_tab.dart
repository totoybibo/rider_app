import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/constants.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rider_app/AllWidgets/prediction_tile.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/Helpers/httprequest.dart';

class SearchDestinationTab extends StatefulWidget {
  static const id = 'searchTab';
  final String userId;
  SearchDestinationTab({this.userId});
  @override
  _SearchDestinationTabState createState() => _SearchDestinationTabState();
}

class _SearchDestinationTabState extends State<SearchDestinationTab> {
  TextEditingController controller = TextEditingController();
  List<PlacePredictions> list = [];
  bool showList = true;
  void findPlace(String value) async {
    if (value.isNotEmpty) {
      String urlAutoComplete =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${value}&key=$googleMapKey&sessiontoken=123456789&components=country:SG';
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
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => showList = !visible);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            maxLines: 2,
            controller: controller,
            style: TextStyle(
                fontFamily: 'bolt-semibold',
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                fontSize: 16),
            onChanged: (value) => findPlace(value),
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              prefixIcon: GestureDetector(
                onDoubleTap: () => controller.clear(),
                child: Icon(
                  Icons.location_pin,
                  color: Colors.redAccent,
                  size: 35,
                ),
              ),
              labelText: 'Pick up location',
            ),
          ),
          showList
              ? Container(
                  //padding: EdgeInsets.only(left: 5, right: 5),
                  height: 180,
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
                            // if (!favorite == true) {
                            //   Map faves = {'name': value.mainText};
                            //   favRef
                            //       .child(widget.userId)
                            //       .child(value.placeId)
                            //       .set(faves);
                            // } else {
                            //   favRef.child(widget.userId).child(value.placeId).remove();
                            // }
                            //
                            // return !favorite;
                          },
                          prediction: place,
                          onTap: (PlacePredictions value) {
                            controller.text = value.mainText;
                            // widget.placesTap(value.placeId);
                          });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
