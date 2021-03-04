import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        shape: RoundedRectangleBorder(),
        highlightColor: Colors.lightBlueAccent.shade200,
        child: Icon(Icons.menu, size: 40, color: Color(0xFFeeaa46)),
      ),
    );
  }
}
