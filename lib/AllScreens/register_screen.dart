import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FToast toast;
  void showToast(String msg) {
    toast.showToast(
      toastDuration: const Duration(seconds: 1),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        color: Colors.lightBlueAccent,
        child: Center(
          child: Text(
            msg,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast = FToast();
  }

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset('images/logo.png',
                width: 350, height: 350, alignment: Alignment.center),
            SizedBox(height: 15),
            Text(
              'Register as Rider',
              style: TextStyle(fontFamily: 'bolt-semibold', fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1),
            TextFormField(
              controller: nameController,
              style: TextStyle(fontSize: 14),
              keyboardType: TextInputType.name,
              decoration: kLoginInputDecoration.copyWith(labelText: 'Name'),
            ),
            TextFormField(
              controller: emailController,
              style: TextStyle(fontSize: 14),
              keyboardType: TextInputType.emailAddress,
              decoration: kLoginInputDecoration,
            ),
            TextFormField(
              controller: phoneController,
              style: TextStyle(fontSize: 14),
              keyboardType: TextInputType.phone,
              decoration: kLoginInputDecoration.copyWith(labelText: 'Phone'),
            ),
            TextFormField(
              controller: passwordController,
              style: TextStyle(fontSize: 14),
              obscureText: true,
              decoration: kLoginInputDecoration.copyWith(labelText: 'Password'),
            ),
            SizedBox(height: 10),
            RaisedButton(
              highlightColor: Colors.yellowAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.yellow,
              textColor: Colors.black,
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontFamily: 'bolt-semibold',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
              onPressed: () async {
                try {
                  if (nameController.text.length < 4) throw 'invalid name';
                  if (emailController.text.length < 5) throw 'invalid email';
                  if (phoneController.text.length < 7)
                    throw 'invalid phone number';
                  if (passwordController.text.length < 5)
                    throw 'invalid password';

                  User usr = (await _auth.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text))
                      .user;

                  if (usr != null) print('${usr.email} now online.');
                } catch (e) {
                  showToast(e.toString());
                }
              },
            ),
            SizedBox(height: 5),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Already have account? Login here',
                style: TextStyle(color: Colors.blueAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
