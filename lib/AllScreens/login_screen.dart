import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'register_screen.dart';
import 'package:firebase_core/firebase_core.dart';

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 65),
            Image.asset('images/logo.png',
                width: 350, height: 350, alignment: Alignment.center),
            SizedBox(height: 15),
            Text(
              'Login as Rider',
              style: TextStyle(fontFamily: 'bolt-semibold', fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1),
            TextFormField(
              style: TextStyle(fontSize: 14),
              keyboardType: TextInputType.emailAddress,
              decoration: kLoginInputDecoration,
              onChanged: (value) => email = value,
            ),
            TextFormField(
              onChanged: (value) => password = value,
              style: TextStyle(fontSize: 14),
              obscureText: true,
              decoration: kLoginInputDecoration.copyWith(labelText: 'Password'),
            ),
            SizedBox(height: 10),
            RaisedButton(
              highlightColor: Colors.yellowAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: animation.value,
              textColor: Colors.black,
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontFamily: 'bolt-semibold',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
              onPressed: () async {
                try {
                  UserCredential cred = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (cred == null) {
                    print('unable to login for user $email');
                  } else {
                    print('successfully logged in.');
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            SizedBox(height: 5),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              child: Text(
                'Register here if you don\'t have account yet',
                style: TextStyle(color: Colors.blueAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
