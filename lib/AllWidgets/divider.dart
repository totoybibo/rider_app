import 'package:flutter/material.dart';

class HDividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey, width: double.infinity, height: 1);
  }
}

class VDividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey, width: 1);
  }
}
