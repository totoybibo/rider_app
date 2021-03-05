import 'package:rider_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'tab_buttons.dart';

class LocationInput extends StatelessWidget {
  final String username;
  final bool isBSOpen;

  final Function searchTap;
  final Function textFormTap;
  final Function collapseTap;
  final Function addHome;
  final Function addWork;
  LocationInput(
      {this.username,
      this.isBSOpen,
      this.searchTap,
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
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: GestureDetector(
                  onTap: searchTap,
                  child:
                      ThemedIcon(context, FontAwesomeIcons.searchLocation, 35),
                ),
                trailing: GestureDetector(
                  onTap: collapseTap,
                  child: ThemedIcon(
                      context,
                      !isBSOpen
                          ? FontAwesomeIcons.chevronCircleUp
                          : FontAwesomeIcons.chevronCircleDown,
                      35),
                ),
                title: TextFormField(
                  style: TextStyle(
                      fontFamily: 'bolt-semibold',
                      fontWeight: FontWeight.bold,
                      color: kDarkModeColor,
                      fontSize: 20),
                  onFieldSubmitted: (value) => print(value),
                  onTap: textFormTap,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration.copyWith(hintText: 'Where to?'),
                ),
              ),
            ),
          ),
          Container(
            child: isBSOpen ? Expanded(child: TabButtons()) : Container(),
          ),
        ],
      ),
    );
  }
}
