import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';
import 'component_widgets.dart';

class FloatingDrawerButton extends StatelessWidget {
  final Function onTap;
  FloatingDrawerButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 50,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: CMaterialButton(onTap, Icons.menu),
    );
  }
}
