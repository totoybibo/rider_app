import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';

class FloatingLocButton extends StatelessWidget {
  final Function onTap;
  FloatingLocButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 190,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: RawMaterialButton(
        constraints: BoxConstraints.tightFor(width: 50, height: 50),
        onPressed: onTap,
        shape: CircleBorder(),
        fillColor: kDarkModeColor,
        highlightColor: Colors.lightBlueAccent.shade200,
        child: Icon(Icons.my_location, size: 40, color: Color(0xFFeeaa46)),
      ),
    );
  }
}
