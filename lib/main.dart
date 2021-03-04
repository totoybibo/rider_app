import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rider_app/AllScreens/login_screen.dart';
import 'package:rider_app/AllScreens/main_screen.dart';
import 'package:rider_app/AllScreens/register_screen.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child('users');

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider',
      theme: ThemeData(
          textTheme: TextTheme(),
          fontFamily: 'bolt-regular',
          brightness: Brightness.dark,
          primaryColor: Colors.blueAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.id,
      routes: {
        MainScreen.id: (context) => MainScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen()
      },
    );
  }
}
