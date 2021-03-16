import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/enums.dart';
import 'package:rider_app/Models/location_model.dart';

class BookCar extends StatefulWidget {
  final Address origin;
  final Address destination;
  final String username;
  final Function onTap;
  BookCar(
      {@required this.origin,
      @required this.destination,
      @required this.username,
      @required this.onTap});

  @override
  _BookCarState createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  ModeOfPayment payment = ModeOfPayment.Cash;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: kDarkModeColor,
          borderRadius: kBorderRadiusAll,
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset('images/taxi.png', width: 80, height: 80),
                  SizedBox(width: 10),
                  Column(children: [
                    Text(
                      'Car',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white70),
                    ),
                    Text('10km', style: TextStyle(fontSize: 16)),
                  ]),
                  SizedBox(width: 20),
                  VDividerWidget(),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Amount', style: TextStyle(color: Colors.white70)),
                      Text('\$40',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  )
                ],
              ),
              HDividerWidget(),
              SizedBox(height: 5),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.blue,
                      children: {
                        ModeOfPayment.Cash: Text(
                          'Cash',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        ModeOfPayment.Card: Text(
                          'Card',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      },
                      groupValue: payment,
                      onValueChanged: (value) =>
                          setState(() => payment = value),
                    ),
                  ),
                  payment == ModeOfPayment.Card
                      ? TextField(
                          decoration: InputDecoration(labelText: 'Card Number'),
                        )
                      : Container(),
                ],
              ),
              HDividerWidget(),
              Row(
                children: [
                  Icon(Icons.location_pin, color: Colors.green, size: 40),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('origin', style: TextStyle(color: Colors.white70)),
                      Text(
                        widget.origin.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              HDividerWidget(),
              RawMaterialButton(
                highlightColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: widget.onTap,
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.redAccent, size: 40),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('destination',
                            style: TextStyle(color: Colors.white70)),
                        Text(
                          'destination',
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              HDividerWidget(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: kPrimaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => print('booked confirmed'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.taxi,
                      size: 25,
                      color: kPrimaryColor,
                    ),
                    SizedBox(width: 20),
                    Text('Request',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kPrimaryColor))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
