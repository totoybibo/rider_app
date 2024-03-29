import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/login_screen.dart';
import 'package:rider_app/AllScreens/main_screen.dart';
import 'package:rider_app/AllScreens/register_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rider_app/DataHandler/app_data.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/AllScreens/destination_screen.dart';
import 'package:rider_app/AllScreens/confirm_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

DatabaseReference dbRef = FirebaseDatabase.instance.reference();
DatabaseReference userRef = dbRef.child('users');
DatabaseReference favRef = dbRef.child('favorites');
DatabaseReference bookingRef = dbRef.child('bookings');

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Rider',
        theme: ThemeData(
            iconTheme: IconThemeData(
              color: kPrimaryColor,
              size: 30,
            ),
            primaryIconTheme: IconThemeData(
              color: kDarkModeColor,
              size: 30,
            ),
            textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.grey),
            ),
            fontFamily: 'bolt-regular',
            brightness: Brightness.dark,
            primaryColor: Colors.blueAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.id,
        routes: {
          MainScreen.id: (context) => MainScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          DestinationScreen.id: (context) => DestinationScreen(),
          ConfirmScreen.id: (context) => ConfirmScreen()
        },
      ),
    );
  }
}
