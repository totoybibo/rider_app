import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rider_app/AllWidgets/divider.dart';

class MainScreenDrawer extends StatelessWidget {
  final String username;
  final User user;
  final Function signOut;
  MainScreenDrawer({this.username, this.user, this.signOut});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 3 * 2,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 200,
              child: DrawerHeader(
                //decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/user_icon.png',
                        width: 100, height: 100),
                    Text(username,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email,
                        style: TextStyle(fontSize: 16, color: Colors.grey))
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            RawMaterialButton(
              onPressed: () {},
              constraints: kBoxConstraints,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              highlightColor: Colors.lightBlueAccent,
              child: ListTile(
                leading: Icon(Icons.star, color: kPrimaryColor),
                title: Text('Favorites', style: TextStyle(fontSize: 16)),
              ),
            ),
            RawMaterialButton(
              onPressed: () {},
              constraints: kBoxConstraints,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              highlightColor: Colors.lightBlueAccent,
              child: ListTile(
                leading: Icon(Icons.history, color: kPrimaryColor),
                title: Text('History', style: TextStyle(fontSize: 16)),
              ),
            ),
            RawMaterialButton(
              onPressed: () {},
              constraints: kBoxConstraints,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              highlightColor: Colors.lightBlueAccent,
              child: ListTile(
                leading: Icon(Icons.person, color: kPrimaryColor),
                title: Text('Visit Profile', style: TextStyle(fontSize: 16)),
              ),
            ),
            RawMaterialButton(
              onPressed: () {},
              constraints: kBoxConstraints,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              highlightColor: Colors.lightBlueAccent,
              child: ListTile(
                leading: Icon(Icons.info, color: kPrimaryColor),
                title: Text('About', style: TextStyle(fontSize: 16)),
              ),
            ),
            RawMaterialButton(
              onPressed: signOut,
              constraints: kBoxConstraints,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              highlightColor: Colors.lightBlueAccent,
              child: ListTile(
                leading: Icon(Icons.logout, color: kPrimaryColor),
                title: Text('Sign Out', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
