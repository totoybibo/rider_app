import 'package:flutter/material.dart';

class FloatingExitButton extends StatelessWidget {
  final Function onTap;
  FloatingExitButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 50,
      right: MediaQuery.of(context).viewInsets.right + 10,
      child: RawMaterialButton(
        constraints: BoxConstraints.tightFor(width: 50, height: 50),
        onPressed: onTap,
        shape: CircleBorder(),
        highlightColor: Colors.lightBlueAccent.shade200,
        child: Icon(Icons.close, size: 40, color: Color(0xFFeeaa46)),
      ),
    );
  }
}
