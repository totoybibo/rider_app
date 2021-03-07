import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';

class FloatingLocButton extends StatelessWidget {
  final Function onTap;
  FloatingLocButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 120,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: CMaterialButton(onTap, Icons.home),
    );
  }
}
