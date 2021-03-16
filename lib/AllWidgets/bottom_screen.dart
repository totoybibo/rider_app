import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/AllWidgets/placelist_tab.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/Helpers/httprequest.dart';
import 'package:rider_app/constants.dart';

class BottomScreen extends StatefulWidget {
  final String userId;
  final Function onTap;
  BottomScreen({@required this.userId, @required this.onTap});
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  List<PlacePredictions> list = [];
  List<PlacePredictions> faveList = [];
  TextEditingController controller = TextEditingController();
  bool showMaxline = false;
  bool isFavorites = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavorites();
  }

  void getFavorites() async {
    await favRef.child(widget.userId).onChildAdded.forEach((element) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
          child: ListTile(
            onLongPress: () {
              controller.clear();
              list = faveList;
              isFavorites = true;
              setState(() => showMaxline = false);
            },
            leading: ThemedIcon(context, Icons.location_pin, 40),
            contentPadding: EdgeInsets.zero,
            title: TextField(
              style: TextStyle(color: Colors.blueAccent),
              onChanged: (value) {
                findPlaces(value);
                setState(() => showMaxline = value.length > 34);
              },
              autocorrect: false,
              enableSuggestions: false,
              controller: controller,
              maxLines: showMaxline ? 2 : 1,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                labelText: 'Where to?',
                labelStyle:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        PlaceListTab(
          userId: widget.userId,
          onTap: (PlacePredictions value) {
            controller.text = value.mainText;
            setState(() => showMaxline = value.mainText.length > 34);
            widget.onTap(value);
          },
          list: list.isNotEmpty ? list : faveList,
        ),
      ],
    );
  }
}
