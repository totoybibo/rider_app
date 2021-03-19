import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/main.dart';
import 'main_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';

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
  bool showSpinner = false;
  void registerUser(BuildContext context) async {
    setState(() => showSpinner = true);
    try {
      if (emailController.text.isEmpty) throw 'email required';
      if (passwordController.text.isEmpty) throw 'password is required';

      User usr = (await _auth
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
              .catchError((error) {
        Fluttertoast.showToast(msg: error.toString());
      }))
          .user;

      if (usr != null) {
        Map userDataMap = {
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'password': passwordController.text
        };
        userRef.child(usr.uid).set(userDataMap);
        Fluttertoast.showToast(
            msg: '${usr.email} created successfully.',
            backgroundColor: Colors.lightBlueAccent,
            gravity: ToastGravity.TOP);
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.id, (route) => false);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), backgroundColor: Colors.blueAccent);
    } finally {
      setState(() => showSpinner = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 30),
              Hero(
                tag: 'logo',
                child: Image.asset('images/logo.png',
                    width: 300, height: 350, alignment: Alignment.center),
              ),
              SizedBox(height: 5),
              Text(
                'Rider Registration',
                style: TextStyle(fontFamily: 'bolt-semibold', fontSize: 24),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: nameController,
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.name,
                decoration: kLoginInputDecoration.copyWith(
                  labelText: 'Name',
                  prefixIcon: ThemedIcon(context, FontAwesomeIcons.user),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: emailController,
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.emailAddress,
                decoration: kLoginInputDecoration.copyWith(
                  labelText: 'Email',
                  prefixIcon: ThemedIcon(context, FontAwesomeIcons.envelope),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text.isEmpty) return '';
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.phone,
                decoration: kLoginInputDecoration.copyWith(
                  labelText: 'Phone',
                  prefixIcon: ThemedIcon(context, FontAwesomeIcons.phone),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: passwordController,
                style: TextStyle(fontSize: 14),
                obscureText: true,
                decoration: kLoginInputDecoration.copyWith(
                  labelText: 'Password',
                  prefixIcon: ThemedIcon(context, FontAwesomeIcons.userLock),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text.isEmpty) return '';
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () => registerUser(context),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontFamily: 'bolt-semibold',
                        fontSize: 18,
                        color: kPrimaryColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: kPrimaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (route) => false);
                },
                child: Text(
                  'Already have account? Login here',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
