import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';

class FloatingFavButton extends StatelessWidget {
  final Function onTap;
  FloatingFavButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 120,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: RawMaterialButton(
        constraints: BoxConstraints.tightFor(width: 50, height: 50),
        elevation: 8,
        onPressed: onTap,
        shape: CircleBorder(),
        fillColor: kDarkModeColor,
        highlightColor: Colors.lightBlueAccent.shade200,
        child: Icon(
          Icons.star,
          size: 40,
          color: Color(0xFFeeaa46),
        ),
      ),
    );
  }
}
