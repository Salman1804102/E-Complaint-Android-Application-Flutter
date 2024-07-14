import 'package:flutter/material.dart';
import 'package:fluttertest/screens/complain_history_screen.dart';
import 'package:fluttertest/screens/home_screen.dart';
import 'package:fluttertest/utils/color_utils.dart';
import 'package:fluttertest/reusable_widgets/reusable_widget.dart';  // Import the reusable widgets

class ComplainConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complain Recorded"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("FFE1F5FE"),
              hexStringToColor("FFB3E5FC"),
              hexStringToColor("FF81D4FA"),
              hexStringToColor("FF4FC3F7")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add logo here
              logoWidget("assets/images/submitted-logo.png"),
              SizedBox(height: 20),
              Text(
                "Your complain has been recorded",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              firebaseUIButton(context, "Go to Home", () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              }),
              SizedBox(height: 20),
              firebaseUIButton(context, "See Your Complain History", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplainHistoryScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
