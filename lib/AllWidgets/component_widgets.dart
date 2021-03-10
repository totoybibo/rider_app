import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';

//Icon Widget
class ThemedIcon extends StatelessWidget {
  final BuildContext xContext;
  final IconData icon;
  final double size;

  ThemedIcon(this.xContext, this.icon, [this.size = 30]);
  @override
  Widget build(BuildContext context) {
    final IconThemeData data = IconTheme.of(xContext);
    return IconTheme(data: data, child: Icon(icon, size: size));
  }
}

// Horizontal Divider
class HDividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey, width: double.infinity, height: 1);
  }
}

// Vertical Divider
class VDividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, width: 1);
  }
}

class CMaterialButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double size;
  CMaterialButton(this.onTap, this.icon, [this.size = 40]);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: 50, height: 50),
      onPressed: onTap,
      shape: CircleBorder(),
      highlightColor: kDarkModeColor,
      child: ThemedIcon(context, icon, size),
    );
  }
}

class RMaterialButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  RMaterialButton({this.onTap, this.child});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap,
      constraints: kBoxConstraints,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      highlightColor: Colors.lightBlueAccent,
      child: child,
    );
  }
}
