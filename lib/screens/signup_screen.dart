import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/reusable_widgets/reusable_widget.dart';
import 'package:fluttertest/screens/home_screen.dart';
import 'package:fluttertest/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  String? _userType;
  final List<String> _userTypes = ["Customer", "Seller"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("FFE1F5FE"),
                hexStringToColor("FFB3E5FC"),
                hexStringToColor("FF81D4FA"),
                hexStringToColor("FF4FC3F7")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableDropdown(
                      _userTypes,
                      _userType,
                      "Select Options",
                          (value) {
                        setState(() {
                          _userType = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outline, false,
                        _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email Id", Icons.email_outlined, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                  firebaseUIButton(context, "Sign Up", () {
                    if (_userType != null) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                          .then((value) {
                        // Create a new user document in Firestore with user type
                        FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
                          'email': _emailTextController.text,
                          'userType': _userType,
                          'userName': _userNameTextController.text
                          // Add other user details if needed
                        }).then((_) {
                          print("User data added to Firestore successfully");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeScreen()));
                        }).catchError((error) {
                          print("Error adding user data to Firestore: $error");
                        });
                      }).catchError((error) {
                        print("Error creating new account: $error");
                      });
                    } else {
                      print("Please select user type");
                    }
                  })
                  ],
                ),
              ))),
    );
  }
}
