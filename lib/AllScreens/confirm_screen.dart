import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/enums.dart';
import 'package:rider_app/Models/location_model.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:rider_app/main.dart';
import 'package:intl/intl.dart';

class ConfirmScreen extends StatefulWidget {
  static const id = 'confirm';
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  ModeOfPayment payment = ModeOfPayment.Cash;
  bool showSpinner = false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppData data = Provider.of<AppData>(context, listen: false);
    Address origin = data.origin;
    Address destination = data.destination;
    String fare = data.calculateFare;
    String distance = data.directionDetails.distanceText;
    String userId = data.userId;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
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
              FontAwesomeIcons.taxi,
              color: Colors.blueGrey,
              size: 40,
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Positioned(
          top: MediaQuery.of(context).viewInsets.top,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: kDarkModeColor,
              borderRadius: kBorderRadiusAll,
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    Image.asset('images/taxi.png', width: 80, height: 80),
                    SizedBox(width: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Car',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white70),
                          ),
                          Text(distance, style: TextStyle(fontSize: 16)),
                        ]),
                    SizedBox(width: 20),
                    VDividerWidget(),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount', style: TextStyle(color: Colors.white70)),
                        Text(fare,
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
                            controller: controller,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            enableSuggestions: false,
                            autocorrect: false,
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
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                    title: Text('destination',
                        style: TextStyle(color: Colors.red)),
                    subtitle: Text(
                      destination.name,
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
                SizedBox(height: 5),
                Container(
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: kPrimaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      setState(() => showSpinner = true);
                      try {
                        Map booking = {};
                        booking = await bookingRef
                            .child(userId)
                            .once()
                            .then((value) => value.value);
                        if (booking['status'] == BookingStatus.New.index) {
                          throw 'You already have a pending request!';
                        }
                        final DateTime now = DateTime.now();
                        final DateFormat formatter =
                            DateFormat('yyyy-MM-dd hh:mm:ss');
                        final String formatted = formatter.format(now);
                        booking = {
                          'distance': distance,
                          'modeOfPaymet': payment.index.toString(),
                          'amount': fare,
                          'cardNumber': controller.text,
                          'status': 0,
                          'originId': origin.placeId,
                          'originAddress': origin.address,
                          'destinationId': destination.placeId,
                          'destinationAddress': destination.address,
                          'bookingDate': formatted
                        };
                        bookingRef.child(userId).set(booking);
                        Fluttertoast.showToast(
                            msg: 'Booking Confirmed!',
                            backgroundColor: Colors.green,
                            gravity: ToastGravity.TOP);
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: e,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.blueAccent);
                      } finally {
                        setState(() => showSpinner = false);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.thumbsUp,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
