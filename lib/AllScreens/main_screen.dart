import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const id = 'main';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Container(child: Image.asset('images/car_android.png')),
    );
  }
}
