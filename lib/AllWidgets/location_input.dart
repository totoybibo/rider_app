import 'package:rider_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'tab_buttons.dart';

class LocationInput extends StatefulWidget {
  final String username;
  final bool isBSOpen;
  final String address;
  final Function searchTap;
  final Function textFormTap;
  final Function collapseTap;
  LocationInput({
    @required this.username,
    @required this.isBSOpen,
    @required this.address,
    @required this.searchTap,
    @required this.textFormTap,
    @required this.collapseTap,
  });

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kDarkModeColor,
        boxShadow: [kBoxShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: GestureDetector(
              onTap: widget.searchTap,
              child: ThemedIcon(context, FontAwesomeIcons.searchLocation, 35),
            ),
            trailing: GestureDetector(
              onTap: widget.collapseTap,
              child: ThemedIcon(
                  context,
                  !widget.isBSOpen
                      ? FontAwesomeIcons.chevronCircleUp
                      : FontAwesomeIcons.chevronCircleDown,
                  35),
            ),
            title: TextFormField(
              initialValue: widget.address,
              style: TextStyle(
                  fontFamily: 'bolt-semibold',
                  fontWeight: FontWeight.bold,
                  color: kDarkModeColor,
                  fontSize: 20),
              onFieldSubmitted: (value) => print(value),
              onTap: widget.textFormTap,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              decoration: kInputDecoration.copyWith(hintText: 'Where to?'),
            ),
          ),
        ),
      ),
    );
  }
}
