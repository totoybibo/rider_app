import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';

class FloatingDrawerButton extends StatelessWidget {
  final Function onTap;
  FloatingDrawerButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 50,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: RawMaterialButton(
        constraints: BoxConstraints.tightFor(width: 50, height: 50),
        elevation: 8,
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        highlightColor: Colors.lightBlueAccent,
        child: Icon(Icons.menu, size: 40, color: kDarkModeColor),
      ),
    );
  }
}
