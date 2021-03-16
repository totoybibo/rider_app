import 'package:flutter/material.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/AllWidgets/prediction_tile.dart';
import 'package:rider_app/main.dart';

class FavoritesTab extends StatefulWidget {
  final Function onTap;
  final List<PlacePredictions> list;
  final String userId;
  FavoritesTab(
      {@required this.onTap, @required this.list, @required this.userId});

  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 220,
          child: ListView.separated(
            itemCount: widget.list.length,
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) => HDividerWidget(),
            itemBuilder: (context, index) {
              PlacePredictions place = widget.list[index];
              return PredictionTile(
                  isFavorite: place.isFavorite,
                  onFavePressed: (PlacePredictions value, bool favorite) {
                    setState(() => place.isFavorite = !favorite);
                    if (place.isFavorite) {
                      Map data = {'name': value.mainText};
                      favRef
                          .child(widget.userId)
                          .child(value.placeId)
                          .set(data);
                    } else {
                      favRef.child(widget.userId).child(value.placeId).remove();
                      widget.list.removeAt(index);
                    }
                  },
                  prediction: place,
                  onTap: widget.onTap);
            },
          ),
        ),
      ],
    );
  }
}
