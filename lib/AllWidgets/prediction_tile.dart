import 'package:flutter/material.dart';
import 'package:rider_app/Models/place_predictions.dart';
import 'component_widgets.dart';

class PredictionTile extends StatelessWidget {
  final PlacePredictions prediction;
  final Function onTap;
  final Function onFavePressed;
  final bool isFavorite;
  PredictionTile(
      {this.prediction, this.onTap, this.onFavePressed, this.isFavorite});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RawMaterialButton(
          constraints: BoxConstraints.tightFor(width: 40, height: 40),
          onPressed: () => onFavePressed(prediction, isFavorite),
          shape: CircleBorder(),
          child: ThemedIcon(
              context,
              isFavorite ?? false ? Icons.star : Icons.star_border_outlined,
              35),
        ),
        RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () => onTap(prediction),
          child: Container(
            width: MediaQuery.of(context).size.width - 80,
            child: Text(
              prediction.mainText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        )
      ],
    );
  }
}
