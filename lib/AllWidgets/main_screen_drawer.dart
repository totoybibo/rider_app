import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';

class MainScreenDrawer extends StatelessWidget {
  final String username;
  final User user;
  final Function signOut;
  MainScreenDrawer({this.username, this.user, this.signOut});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 * 2,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
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
              RMaterialButton(
                onTap: () {},
                child: ListTile(
                  leading: ThemedIcon(context, Icons.star),
                  title: Text('Favorites', style: TextStyle(fontSize: 16)),
                ),
              ),
              RMaterialButton(
                onTap: () {},
                child: ListTile(
                  leading: ThemedIcon(context, Icons.history),
                  title: Text('History', style: TextStyle(fontSize: 16)),
                ),
              ),
              RMaterialButton(
                onTap: () {},
                child: ListTile(
                  leading: ThemedIcon(context, Icons.person),
                  title: Text('Visit Profile', style: TextStyle(fontSize: 16)),
                ),
              ),
              RMaterialButton(
                onTap: () {},
                child: ListTile(
                  leading: ThemedIcon(context, Icons.info),
                  title: Text('About', style: TextStyle(fontSize: 16)),
                ),
              ),
              RMaterialButton(
                onTap: signOut,
                child: ListTile(
                  leading: ThemedIcon(context, Icons.logout),
                  title: Text('Sign Out', style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
