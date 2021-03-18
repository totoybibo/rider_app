import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/main_screen.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/main.dart';
import 'register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'package:rider_app/AllWidgets/component_widgets.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/app_data.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  void loginUser(BuildContext context) async {
    try {
      setState(() => showSpinner = true);

      if (email == null || email.isEmpty) throw 'please provide email';
      if (!email.contains('@')) throw 'incorrect email';
      if (password == null || password.isEmpty) throw 'password is empty';

      User usr = (await _auth
              .signInWithEmailAndPassword(email: email, password: password)
              .catchError((e) {
        //Fluttertoast.showToast(msg: e.toString());
      }))
          .user;

      if (usr == null) {
        throw 'user email/password is invalid';
      } else {
        await userRef.child(usr.uid).once().then((snap) {
          if (snap != null) {
            String name = snap.value['name'];
            Provider.of<AppData>(context, listen: false).setUser = usr;
            Provider.of<AppData>(context, listen: false).userName = name;
            Fluttertoast.showToast(
                msg: 'Welcome $name',
                backgroundColor: Colors.lightBlueAccent,
                gravity: ToastGravity.TOP);

            Navigator.pushNamedAndRemoveUntil(
                context, MainScreen.id, (route) => false);
          } else {
            throw 'user email/password is invalid';
            _auth.signOut();
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'user email/password is invalid', backgroundColor: Colors.blue);
    } finally {
      setState(() => showSpinner = false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    animation = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller.forward();
    animation =
        ColorTween(begin: Colors.white, end: Colors.yellow).animate(controller);
    animation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Hero(
                  tag: 'logo',
                  child: Image.asset('images/logo.png',
                      width: 350, height: 350, alignment: Alignment.center),
                ),
                SizedBox(height: 5),
                Text(
                  'Login as Rider',
                  style: TextStyle(fontFamily: 'bolt-semibold', fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  decoration: kLoginInputDecoration.copyWith(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellow,
                      ),
                    ),
                    prefixIcon: ThemedIcon(context, Icons.email),
                    suffixIcon: GestureDetector(
                      child: kInfoIcon,
                      onTap: () {
                        Fluttertoast.showToast(
                            gravity: ToastGravity.TOP,
                            msg: 'Email Address required',
                            backgroundColor: Colors.lightBlueAccent);
                      },
                    ),
                  ),
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  onChanged: (value) => password = value,
                  style: TextStyle(fontSize: 14),
                  obscureText: true,
                  decoration: kLoginInputDecoration.copyWith(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellow,
                      ),
                    ),
                    prefixIcon: ThemedIcon(context, FontAwesomeIcons.userLock),
                    suffixIcon: GestureDetector(
                      child: kInfoIcon,
                      onTap: () {
                        Fluttertoast.showToast(
                            gravity: ToastGravity.TOP,
                            msg: 'Password required',
                            backgroundColor: Colors.lightBlueAccent.shade700);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(
                        color: kPrimaryColor,
                        width: 3,
                      ),
                    ),
                    onPressed: () => loginUser(context),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'bolt-semibold',
                        fontSize: 18,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.id, (route) => false);
                  },
                  child: Text(
                    'Register here if you don\'t have account yet',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
