import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/enums.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/app_data.dart';

class ConfirmScreen extends StatefulWidget {
  static const id = 'confirm';
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  ModeOfPayment payment = ModeOfPayment.Cash;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    Address origin = Provider.of<AppData>(context).origin;
    Address destination = Provider.of<AppData>(context).destination;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: kDarkModeColor,
        leading: RawMaterialButton(
          onPressed: () => Navigator.pop(context),
          shape: CircleBorder(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey,
            size: 30,
          ),
        ),
        title: Container(
          child: ListTile(
            title: Text(
              'Confirm Booking',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              FontAwesomeIcons.thumbsUp,
              color: Colors.blueGrey,
              size: 40,
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: Container(
            decoration: BoxDecoration(
              color: kDarkModeColor,
              borderRadius: kBorderRadiusAll,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                          Text('Amount',
                              style: TextStyle(color: Colors.white70)),
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            ModeOfPayment.Card: Text(
                              'Card',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          },
                          groupValue: payment,
                          onValueChanged: (value) =>
                              setState(() => payment = value),
                        ),
                      ),
                      payment == ModeOfPayment.Card
                          ? TextField(
                              decoration: InputDecoration(
                                  labelText: 'Card Number',
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none)),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 5),
                  HDividerWidget(),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      title:
                          Text('origin', style: TextStyle(color: Colors.green)),
                      subtitle: Text(
                        origin.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  HDividerWidget(),
                  RawMaterialButton(
                    highlightColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {},
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title: Text('destination',
                            style: TextStyle(color: Colors.red)),
                        subtitle: Text(
                          destination.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
        ),
      ),
    );
  }
}
