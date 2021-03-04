import 'package:rider_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'divider.dart';
import 'tab_buttons.dart';

class LocationInput extends StatelessWidget {
  final String username;
  final int bottomFlex;
  final TextEditingController controller;
  final Function textFormTap;
  final Function collapseTap;
  final Function addHome;
  final Function addWork;
  LocationInput(
      {this.username,
      this.bottomFlex,
      this.controller,
      this.textFormTap,
      this.collapseTap,
      this.addHome,
      this.addWork});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kDarkModeColor,
        boxShadow: [kBoxShadow],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                trailing: GestureDetector(
                  onTap: collapseTap,
                  child: Icon(
                    bottomFlex == 1
                        ? FontAwesomeIcons.chevronCircleUp
                        : FontAwesomeIcons.chevronCircleDown,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.searchLocation,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                title: TextFormField(
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 18),
                  onFieldSubmitted: (value) => print(value),
                  controller: controller,
                  onTap: textFormTap,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Where to $username?'),
                ),
              ),
            ),
          ),
          Container(
            child:
                bottomFlex == 1 ? Container() : Expanded(child: TabButtons()),
          ),
        ],
      ),
    );
  }
}
