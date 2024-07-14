import 'package:flutter/material.dart';
import 'package:fluttertest/screens/complain_history_screen.dart';
import 'package:fluttertest/screens/customer_complain_screen.dart';
import 'package:fluttertest/screens/seller_complain_screen.dart';
import 'package:fluttertest/screens/legal_information_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/screens/signin_screen.dart';
import 'package:fluttertest/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/screens/admin_complain_history.dart';
import 'lawyer.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalComplaints = 0;
  int resolvedComplaints = 0;
  int userComplaints = 0;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final complaints = await FirebaseFirestore.instance.collection('complaints').get();
      final resolved = complaints.docs.where((doc) => doc['status'] == 'Resolved').length;
      final userSpecific = complaints.docs.where((doc) => doc['email'] == user.email).length;

      setState(() {
        totalComplaints = complaints.size;
        resolvedComplaints = resolved;
        userComplaints = userSpecific;
        isAdmin = user.email == 'admin@gmail.com';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Complainer"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              icon: Icon(Icons.logout, size: 30),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                });
              },
            ),
          ),
        ],
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
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Complaint Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: isAdmin ? 2 : 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildStatCard('Total Complaints', totalComplaints, Colors.orange),
                    buildStatCard('Resolved Complaints', resolvedComplaints, Colors.green),
                    if (!isAdmin) buildStatCard('Your Complaints', userComplaints, Colors.blue),
                  ],
                ),
                SizedBox(height: 20),
                if (isAdmin) buildAdminButtons(context) else buildUserButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, int count, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdminButtons(BuildContext context) {
    return Column(
      children: [
        Text(
          "Customer's Complaints",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        buildComplainButton(context, 'No-Delivery'),
        buildComplainButton(context, 'Counterfeit Product'),
        buildComplainButton(context, 'Faulty or Damaged Goods'),
        buildComplainButton(context, 'Misrepresentation of Product'),
        buildComplainButton(context, 'Late Delivery'),
        buildComplainButton(context, 'Unauthorized Charges'),
        SizedBox(height: 20),
        Text(
          "Seller's Complaints",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        buildComplainButton(context, 'Change of Mind'),
        buildComplainButton(context, 'Wrong Shipping Address'),
      ],
    );
  }

  Widget buildComplainButton(BuildContext context, String complainType) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminComplainHistoryScreen(complainType: complainType)),
          );
        },
        child: Text(
          complainType,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildUserButtons(BuildContext context) {
    return Column(
      children: [
        homeScreenButton(
          context,
          "Your Complain History",
          Icons.history,
          ComplainHistoryScreen(),
        ),
        homeScreenButton(
          context,
          "Submit Your Complain",
          Icons.store,
          ComplainScreen(),
        ),
        homeScreenButton(
          context,
          "Legal Information",
          Icons.info,
          LegalInformationScreen(),
        ),
        homeScreenButton(
          context,
          "Consult With Lawyer",
          Icons.gavel,
          LawyerPage(),
        ),
      ],
    );
  }

  Widget homeScreenButton(BuildContext context, String title, IconData icon, Widget screen) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
