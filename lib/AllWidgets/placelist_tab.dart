import 'package:flutter/material.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/AllWidgets/prediction_tile.dart';
import 'package:rider_app/main.dart';

class PlaceListTab extends StatelessWidget {
  final Function onTap;
  final List<PlacePredictions> list;
  final String userId;
  PlaceListTab(
      {@required this.onTap, @required this.list, @required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, index) => HDividerWidget(),
      itemBuilder: (context, index) {
        PlacePredictions place = list[index];
        return PredictionTile(
            isFavorite: place.isFavorite,
            onFavePressed: (PlacePredictions value, bool favorite) {
              place.isFavorite = !favorite;
              if (place.isFavorite) {
                Map data = {'name': value.mainText};
                favRef.child(userId).child(value.placeId).set(data);
              } else {
                favRef.child(userId).child(value.placeId).remove();
                list.removeAt(index);
              }
            },
            prediction: place,
            onTap: onTap);
      },
    );
  }
}
