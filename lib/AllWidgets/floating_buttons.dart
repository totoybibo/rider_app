import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'component_widgets.dart';
import 'package:rider_app/constants.dart';

class ToggleButton extends StatelessWidget {
  final Function onTap;
  final bool isBSOpen;

  ToggleButton({this.onTap, this.isBSOpen});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: isBSOpen ? MediaQuery.of(context).size.height / 1.8 + 10 : 170,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: CMaterialButton(onTap,
          isBSOpen ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp, 35),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final Function onTap;
  DrawerButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 50,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: CMaterialButton(onTap, Icons.menu),
    );
  }
}

class HomeButton extends StatelessWidget {
  final Function onTap;
  HomeButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewInsets.top + 120,
      left: MediaQuery.of(context).viewInsets.left + 10,
      child: CMaterialButton(onTap, Icons.home),
    );
  }
}

class FavoritesButton extends StatelessWidget {
  final Function onTap;
  FavoritesButton({this.onTap});
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
