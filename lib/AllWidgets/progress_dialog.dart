import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String message;
  ProgressDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: Colors.white),
        child: Row(
          children: [
            SizedBox(height: 6),
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            SizedBox(width: 26),
            Text(message, style: TextStyle(color: Colors.black))
          ],
        ),
      ),
    );
  }
}
