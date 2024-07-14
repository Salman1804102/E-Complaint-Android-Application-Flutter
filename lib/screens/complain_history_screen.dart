import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/utils/color_utils.dart';

class ComplainHistoryScreen extends StatelessWidget {
  const ComplainHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Complain History"),
        ),
        body: Center(
          child: const Text("Please log in to view your complain history."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Submitted Complains"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("FFE1F5FE"),
              hexStringToColor("FFB3E5FC"),
              hexStringToColor("FF81D4FA"),
              hexStringToColor("FF4FC3F7"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('complaints')
              .where('email', isEqualTo: user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No complaints found.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            final complaints = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8,
              ),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                var complaint = complaints[index].data() as Map<String, dynamic>;
                String _userType = complaint['userType'];
                return Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _userType == "Customer" ? _buildCustomerComplainHistory(complaint) : _buildSellerComplainHistory(complaint),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  List<Widget> _buildCustomerComplainHistory(Map<String, dynamic> complaint) {
    return
      [
        Text(
          "1. Name: ${complaint['name']}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "2. Age: ${complaint['age']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "3. Gender: ${complaint['gender']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "4. Education: ${complaint['education']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "5. Location: ${complaint['location']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "6. Fraud Awareness: ${complaint['fraudAwareness']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "7. Product Bought From: ${complaint['shopName']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "8. Order Date: ${complaint['orderDate']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "9. Payment Method: ${complaint['paymentMethod']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "10. Transaction ID: ${complaint['transactionId']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "11. Onsite Outlet Availability of Shop: ${complaint['onsiteOutlet']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "12. Contact Information with Seller: ${complaint['contactedSeller']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "13. Seller Response After Contact: ${complaint['sellerResponse']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "14. Return Agreement of Seller: ${complaint['returnAgreement']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "15. Read Description Before Buy?: ${complaint['readDescription']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "16. Read Return Policy Before Buy?: ${complaint['readReturnPolicy']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "17. Product Has Unusual Discount?: ${complaint['unusualDiscount']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "18. Item Received or Not: ${complaint['itemReceived']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "19. Seller Provide Tracking Info?: ${complaint['trackingInfo']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "20. Status of the Product: ${complaint['counterfeit']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "21. Product Authenticity Checked: ${complaint['authenticityCheck']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "22. Exceeded Promised Delivery Timeframe?: ${complaint['deliveryTimeframe']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "23. Delivery Delay Duration: ${complaint['deliveryDelay']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "24. Any Unauthorized Charges?: ${complaint['unauthorizedCharges']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "25. Shared Payment Info With Anyone?: ${complaint['sharedPaymentInfo']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "26. Status: ${complaint['status'] ?? 'Pending'}",
          style: TextStyle(
            color: complaint['status'] == 'Resolved'
                ? Colors.green
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
  }
  List<Widget> _buildSellerComplainHistory(Map<String, dynamic> complaint) {
    return [
        Text(
          "1. Your Shop Name: ${complaint['shopName']}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "2. Business Duration: ${complaint['businessDuration']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "3. Registered Or Not: ${complaint['registered']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "4. Onsite Outlet Availability: ${complaint['onsiteOutlet']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "5. When Ordered by Customer: ${complaint['orderDate']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "6. Advance Paid?: $complaint['advancePayment']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "7. Did Customre's Mind Changed?: ${complaint['changeOfMind']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "8. You Violated Terms and Condition: ${complaint['termsViolated']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "9. Your Response: ${complaint['response']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "10. Customer Provide Incorrect Address?: ${complaint['incorrectAddress']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "11. You Violated Any Return Policy?: ${complaint['returnPolicyViolated']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "12. Any Policy Regarding Return?: ${complaint['specificPolicies']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "13. Communicated With Customer?: ${complaint['communicated']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "14. Any Evidence?: ${complaint['evidence']}",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          "15. Status: ${complaint['status']}",
          style: TextStyle(
            color: complaint['status'] == 'Resolved' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
  }
}
