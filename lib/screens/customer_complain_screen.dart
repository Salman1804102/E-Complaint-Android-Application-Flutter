import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/screens/complain_confirmation_screen.dart';
import 'package:fluttertest/utils/color_utils.dart';
import 'package:fluttertest/reusable_widgets/reusable_widget.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:fluttertest/screens/complain_confirmation_screen.dart';
// import 'package:fluttertest/utils/color_utils.dart';
// import 'package:fluttertest/reusable_widgets/reusable_widget.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:image_picker_web/image_picker_web.dart';
// import 'dart:typed_data';
// import 'dart:html' as html;  // For web file picking
// import 'dart:io' as io; // For mobile file picking

class ComplainScreen extends StatefulWidget {
  @override
  _ComplainScreenState createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  String? userType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userType = userDoc['userType'];
        isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _setComplainType();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        formData['email'] = user.email;
        formData['userType'] = userType;
        formData['timestamp'] = Timestamp.now();
        formData['status'] = "Pending";
      } else {
        print('User is not logged in');
        return;
      }

      await FirebaseFirestore.instance.collection('complaints').add(formData);
      print('Data added to Firestore successfully');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ComplainConfirmationScreen()),
      );
    }
  }
  void _setComplainType() {
    if (userType == 'Customer') {
      if (formData['itemReceived'] == "Seller never delivered the item (সেলার প্রডাক্টি কখনোই ডেলিভারি দেয় নি)") {
        formData['complainType'] = 'No-Delivery';
      } else if (formData['counterfeit'] == "I got completely a fake product (আমি সম্পূর্ণভাবে ফেক বা অন্য একটি প্রডাক্ট পেয়েছিলাম)") {
        formData['complainType'] = 'Counterfeit Product';
      } else if (formData['counterfeit'] == "I received a poor quality, faulty or damaged product (আমি একটি খারাপ বা লো কোয়ালিটি প্রোডাক্ট পেয়েছিলাম)") {
        formData['complainType'] = 'Faulty or Damaged Goods';
      } else if (formData['counterfeit'] == "There was discrepancies in packaging (প্যাকেজিং এ তারতম্য ছিলো, প্যাকেজিং ভালো ছিলো না)" ||
          formData['counterfeit'] == "There was inconsistencies in branding/logo (যেই ব্র্যান্ডের প্রডাক্ট অর্ডার করেছি, অন্য একটি প্রডাক্ট ধরিয়ে দিয়েছে)" ||
          formData['counterfeit'] == "There was some missing parts in the product (প্রডাক্টে কিছু মিসিং পার্ট ছিলো)") {
        formData['complainType'] = 'Misrepresentation of Product';
      } else if (formData['deliveryTimeframe'] == "Yes (হ্যাঁ)") {
        formData['complainType'] = 'Late Delivery';
      } else if (formData['unauthorizedCharges'] == "Yes (হ্যাঁ)") {
        formData['complainType'] = 'Unauthorized Charges';
      }
    } else if (userType == 'Seller') {
      if (formData['changeOfMind'] == "Yes (হ্যাঁ)") {
        formData['complainType'] = 'Change of Mind';
      } else if (formData['incorrectAddress'] == "Yes (হ্যাঁ)") {
        formData['complainType'] = 'Wrong Shipping Address';
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        formData['orderDate'] = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Complain"),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complain"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // children: _buildCustomerQuestions(),
              children: userType == 'Customer' ? _buildCustomerQuestions() : _buildSellerQuestions(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCustomerQuestions() {
    return [
      ReusableTextField(
        question: "1. What is your name? (আপনার নাম কি?)",
        hintText: "Enter your name",
        onSaved: (value) {
          formData['name'] = value;
        },
      ),
      ReusableDropdown(
        question: "2. What is your age? (আপনার বয়স কত?)",
        hintText: "Select age",
        options: [
          "Below 18 (১৮ বছরের নিচে)",
          "18-25 (১৮ - ২৫)",
          "26-35 (২৬ - ৩৫)",
          "36-45(৩৬-৪৫)",
          "46-55 (৪৬ - ৫৫)",
          "Above 55 (৫৫ এর উপরে)"
        ],
        onChanged: (value) {
          formData['age'] = value;
        },
      ),
      ReusableDropdown(
        question: "3. What is your gender? (আপনার লিঙ্গ কি?)",
        hintText: "Select gender",
        options: ["Male (পুরুষ)", "Female (মহিলা)"],
        onChanged: (value) {
          formData['gender'] = value;
        },
      ),
      ReusableDropdown(
        question: "4. What is your highest level of education? (আপনার সর্বোচ্চ শিক্ষাগত যোগ্যতা কি?)",
        hintText: "Select education level",
        options: [
          "SSC",
          "HSC",
          "Diploma",
          "Bachelor's Degree",
          "Master's Degree",
          "Doctorate (Ph.D.)"
        ],
        onChanged: (value) {
          formData['education'] = value;
        },
      ),
      ReusableDropdown(
        question: "5. Where do you live in? (আপনি কোথায় বাস করেন?)",
        hintText: "Select location",
        options: ["Rural area (গ্রামীণ এলাকায়)", "Urban Area (শহুরে এলাকায়)"],
        onChanged: (value) {
          formData['location'] = value;
        },
      ),
      ReusableDropdown(
        question: "6. How aware are you of the risks of fraud in online transactions? (অনলাইন লেনদেনে জালিয়াতির ঝুঁকি সম্পর্কে আপনি কতটা সচেতন?)",
        hintText: "Select awareness",
        options: ["Very aware (খুবই সচেতন)", "Somewhat aware (কিছুটা সচেতন)", "Not aware at all (একেবারেই সচেতন নই)"],
        onChanged: (value) {
          formData['fraudAwareness'] = value;
        },
      ),
      ReusableTextField(
        question: "7. From which online shop did you purchase that product when you were victim of fraud? (আপনি প্রতারণার শিকার হয়েছেন যখন তখন আপনি কোন অনলাইন দোকান থেকে সেই পণ্যটি কিনেছিলেন?)",
        hintText: "Enter shop name",
        onSaved: (value) {
          formData['shopName'] = value;
        },
      ),
      ReusableDropdown(
        question: "8. How did you pay the product price? (আপনি কিভাবে পণ্যের মূল্য পরিশোধ করেছেন?)",
        hintText: "Select payment method",
        options: ["bkash", "Nagad", "Rocket", "Cash on delivery", "Credit Card", "Sure Cash", "Other"],
        onChanged: (value) {
          formData['paymentMethod'] = value;
        },
      ),
      ReusableTextField(
        question: "9. Give the Transaction ID or OrderID (ট্রাঞ্জেকশন আইডি বা অর্ডার আইডি প্রদান করুন)",
        hintText: "Enter Transaction ID/OrderID",
        onSaved: (value) {
          formData['transactionId'] = value;
        },
      ),
      ReusableDropdown(
        question: "10. Do the shop have any onsite outlet? (ঐ দোকানটির কি কোন অনসাইট আউটলেট আছে?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['onsiteOutlet'] = value;
        },
      ),
      Text(
        "11. Select an approximate date when you ordered the product (আপনি পণ্যটি অর্ডার করার একটি আনুমানিক তারিখ নির্বাচন করুন)",
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: () => _selectDate(context),
        child: Text("Pick date"),
      ),
      SizedBox(height: 8),
      if (formData['orderDate'] != null)
        Text("Selected date: ${formData['orderDate']}"),
      SizedBox(height: 16),
      ReusableDropdown(
        question: "12. Did you contact with the seller regarding the issue? (আপনি প্রতারণাটি সম্পর্কে বিক্রেতার সাথে যোগাযোগ করেছেন?)",
        hintText: "Select answer",
        options: ["Yes, I contacted (হ্যাঁ, আমি যোগাযোগ করেছি)", "No, I didn't contact (না, আমি যোগাযোগ করি নি)"],
        onChanged: (value) {
          formData['contactedSeller'] = value;
        },
      ),
      ReusableDropdown(
        question: "13. What was the response from the seller? (বিক্রেতার প্রতিক্রিয়া কি ছিল?)",
        hintText: "Select response",
        options: [
          "No, I didn't contact with the seller (না, আমি বিক্রেতার সাথে যোগাযোগ করি নি)",
          "They never listen to my words (তারা কখনো আমার কথা শুনে নি)",
          "They respond to the complain but never solved (তারা কমপ্লেইনটি শুনেছে, কিন্তু সমাধান করে নি)"
        ],
        onChanged: (value) {
          formData['sellerResponse'] = value;
        },
      ),
      ReusableDropdown(
        question: "14. Did they agree to take the product in return? (তারা কি বিনিময়ে পণ্যটি ফেরত নিতে রাজি হয়েছিল?)",
        hintText: "Select answer",
        options: [
          "The product was not delivered ever, hence no question of return (আমাকে পণ্যটি ডেলিভারিই দেওয়া হয় নি)",
          "I don't want to return the product back (আমি পণ্যটি ফেরত দিতে চাই নি)",
          "Yes, they agreed (হ্যাঁ, তারা রাজি হয়েছিলো)",
          "No, they didn't agree (না, তারা রাজি হয় নি)"
        ],
        onChanged: (value) {
          formData['returnAgreement'] = value;
        },
      ),
      ReusableDropdown(
        question: "15. Did you read the product description carefully before buying the product? (আপনি পণ্য কেনার আগে পণ্যের বিবরণ মনোযোগ সহকারে পড়েছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['readDescription'] = value;
        },
      ),
      ReusableDropdown(
        question: "16. Did you read the return policy of the seller before purchasing the product? (আপনি কি পণ্য কেনার আগে বিক্রেতার রিটার্ন পলিসি পড়েছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['readReturnPolicy'] = value;
        },
      ),
      ReusableDropdown(
        question: "17. Did the product have an unusual discount or pricing? (পণ্যটিতে কি অস্বাভাবিক ছাড় বা মূল্য ছিল?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['unusualDiscount'] = value;
        },
      ),
      ReusableDropdown(
        question: "18. Did you receive the item you ordered? (আপনি অর্ডার করা আইটেমটি পেয়েছেন, নাকি পণ্যটি ডেলিভারই পান নি?)",
        hintText: "Select answer",
        options: [
          "I received the item (হ্যাঁ আমি পন্যটি হাতে পেয়েছিলাম)",
          "Seller never delivered the item (সেলার প্রডাক্টি কখনোই ডেলিভারি দেয় নি)",
          "Delivery attempted but failed (ডেলিভারি দেওয়ার চেষ্টা করেছে, কিন্তু বারবার ব্যার্থ হয়েছে)",
          "Item(s) lost in transit (আইটেম কুরিয়ারে ট্রানজিট করার সময় হারিয়ে গিয়েছে)"
        ],
        onChanged: (value) {
          formData['itemReceived'] = value;
        },
      ),
      ReusableDropdown(
        question: "19. Did the seller provide any tracking information or updates on the delivery attempt for your purchase? (বিক্রেতা কি আপনাকে কোন ট্র্যাকিং নাম্বার বা পণ্যের ব্যাপারে আপডেট প্রদান করেছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['trackingInfo'] = value;
        },
      ),
      ReusableDropdown(
        question: "20. Did the item you received were counterfeit or fake, please select all that apply? (আইটেমটি বা প্রডাক্টি কি ফেক ছিলো বা যেটা অর্ডার করেছেন সেটা দেয় নি এমন হয়েছে? এক্ষেত্রে প্রযোজ্য সব অপশন নির্বাচন করুন ।)",
        hintText: "Select issue",
        options: [
          "The product was never delivered (প্রডাক্টটি কখনোই ডেলিভারি দেওয়া হয় নি)",
          "No, I got the correct product (আমি সঠিক প্রডাক্টিই পেয়েছিলাম)",
          "I got completely a fake product (আমি সম্পূর্ণভাবে ফেক বা অন্য একটি প্রডাক্ট পেয়েছিলাম)",
          "I received a poor quality, faulty or damaged product (আমি একটি খারাপ বা লো কোয়ালিটি প্রোডাক্ট পেয়েছিলাম)",
          "There was discrepancies in packaging (প্যাকেজিং এ তারতম্য ছিলো, প্যাকেজিং ভালো ছিলো না)",
          "There was inconsistencies in branding/logo (যেই ব্র্যান্ডের প্রডাক্ট অর্ডার করেছি, অন্য একটি প্রডাক্ট ধরিয়ে দিয়েছে)",
          "There was some missing parts in the product (প্রডাক্টে কিছু মিসিং পার্ট ছিলো)"
        ],
        onChanged: (value) {
          formData['counterfeit'] = value;
        },
      ),
      ReusableDropdown(
        question: "21. Have you attempted to verify the authenticity of the product after purchase? (আপনি কি ক্রয়ের পর পণ্যটির সত্যতা যাচাই করার চেষ্টা করেছেন?)",
        hintText: "Select answer",
        options: [
          "The product was never delivered (প্রডাক্টটি কখনোই ডেলিভারি দেওয়া হয় নি)",
          "I got the correct product (আমি সঠিক প্রডাক্টি পেয়েছি)",
          "No, I never tried (না, আমি চেষ্টা করি নি)",
          "Compared with authentic product (অথেনটিক প্রডাক্ট এর সাথে তুলনা করেছিলাম)",
          "Online research (অনলাইনে খোজাখুজি করেছিলাম)",
          "Consulting an expert (একজন অভিজ্ঞ ও দক্ষ ব্যাক্তির পরামর্শ নিয়েছি)"
        ],
        onChanged: (value) {
          formData['authenticityCheck'] = value;
        },
      ),
      ReusableDropdown(
        question: "22. Did the delivery of your item exceed the promised timeframe? (আপনার অর্ডারকৃত পণ্যটির ডেলিভারি কি প্রতিশ্রুত সময়সীমা অতিক্রম করেছিলো?",
        hintText: "Select answer",
        options: [
          "The product was never delivered (প্রডাক্টটি কখনোই ডেলিভারি দেওয়া হয় নি)",
          "Yes (হ্যাঁ)",
          "No (না)"
        ],
        onChanged: (value) {
          formData['deliveryTimeframe'] = value;
        },
      ),
      ReusableDropdown(
        question: "23. By how many days was the delivery delayed? (ডেলিভারি দিতে কতদিন দেরি হয়েছিলো?)",
        hintText: "Select delay period",
        options: [
          "The product was never delivered (প্রডাক্টটি কখনোই ডেলিভারি দেওয়া হয় নি)",
          "No, it arrived within due date (সঠিক সময়ে পন্য হাতে পেয়েছিলাম)",
          "1-3 days (১ - ৩ দিন)",
          "4-7 days (৪ - ৭ দিন)",
          "More than 7 days (৭ দিনের অধিক)"
        ],
        onChanged: (value) {
          formData['deliveryDelay'] = value;
        },
      ),
      ReusableDropdown(
        question: "24. Have you noticed any unauthorized charges on your account while purchasing that product? (আপনি কি সেই পণ্যটি কেনার সময় আপনার অ্যাকাউন্টে কোনো অননুমোদিত চার্জ লক্ষ্য করেছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['unauthorizedCharges'] = value;
        },
      ),
      ReusableDropdown(
        question: "25. Did you share your payment information with anyone else? (আপনি কি আপনার পেমেন্ট এর কোনো তথ্য অন্য কারো সাথে শেয়ার করেছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['sharedPaymentInfo'] = value;
        },
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _submitForm,
        child: Text("Submit"),
      ),
    ];
  }
  List<Widget> _buildSellerQuestions() {
    return [
      ReusableTextField(
        question: "1. What is your shop name? (আপানার দোকানের নাম কি)",
        hintText: "Enter your shop name",
        onSaved: (value) {
          formData['shopName'] = value;
        },
      ),
      ReusableDropdown(
        question: "2. How long you are doing business in online? (আপনি কতদিন ধরে অনলাইনে ব্যাবসা করছেন)",
        hintText: "Select duration",
        options: [
          "Less than 1 year (এক বছরের কম)",
          "1-3 years (১ - ৩ বছর)",
          "4-6 years (৪-৬ বছর)",
          "7-10 years (৭-১০ বছর)",
          "More than 10 years (১০ বছরের অধিক)"
        ],
        onChanged: (value) {
          formData['businessDuration'] = value;
        },
      ),
      ReusableDropdown(
        question: "3. Are you registered by any legal authority? (আপনার প্রতিষ্ঠানতি কি কোনো আইনগত কর্তৃপক্ষ দ্বারা স্বীকৃত?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['registered'] = value;
        },
      ),
      ReusableDropdown(
        question: "4. Do you have any onsite outlet? (আপনার কি কোন অনসাইট আউটলেট আছে?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['onsiteOutlet'] = value;
        },
      ),
      Text(
        "5. Provide the date of transaction (লেনদেনের তারিখটি দিন)",
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: () => _selectDate(context),
        child: Text("Pick date"),
      ),
      SizedBox(height: 8),
      if (formData['orderDate'] != null)
        Text("Selected date: ${formData['orderDate']}"),
      SizedBox(height: 16),

      ReusableDropdown(
        question: "6. Did the customer pay the money in advance beforehand of the delivery? (গ্রাহক কি ডেলিভারির আগে টাকা অগ্রিম পরিশোধ করেছেন?)",
        hintText: "Select answer",
        options: [
          "It was cash on delivery (ক্যাশ অন ডেলিভারি ছিলো)",
          "Customer paid 50% or less in advance (কাস্টমার ৫০% বা তার কম অগ্রীম প্রদান করেছিলেন)",
          "Customer paid more than 50% in advance (কাস্টমার ৫০% বা তার বেশী অগ্রীম প্রদান করেছিলেন)"
        ],
        onChanged: (value) {
          formData['advancePayment'] = value;
        },
      ),
      ReusableDropdown(
        question: "7. Did the customer refuse to take the product because of a change of mind? (গ্রাহক কি ইচ্ছার পরিবর্তন হয়েছে, নিতে ইচ্ছা করতেছে না এমনটি বলে পণ্যটি নিতে অস্বীকার করেছিলেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['changeOfMind'] = value;
        },
      ),
      ReusableDropdown(
        question: "8. Were there any specific terms or conditions related to payment that you violated in that transaction? (অর্থপ্রদানের সাথে সম্পর্কিত কোন নির্দিষ্ট শর্ত বা শর্তাবলী এমন ছিল যা আপনি সেই লেনদেনে লঙ্ঘন করেছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['termsViolated'] = value;
        },
      ),
      ReusableDropdown(
        question: "9. How did you respond to the customer's refusal to accept the product? (গ্রাহকের পণ্যটি গ্রহণ করতে অস্বীকার করার প্রতিক্রিয়া সরুপ আপনি কি পদক্ষেপ নিয়েছেন?)",
        hintText: "Select response",
        options: [
          "Customer stopped communication, can't do anything (কাস্টমার যোগাযোগ বন্ধ রেখেছেন)",
          "Attempted Re-Delivery (পুনরায় ডেলিভারি দেওয়ার চেষ্টা করেছি)",
          "Offered Refund (টাকা পরিশোধ করতে চেয়েছি)",
          "Initiated Return Process (রিটার্ণ প্রক্রিয়া শুরু করেছিলাম)"
        ],
        onChanged: (value) {
          formData['response'] = value;
        },
      ),
      ReusableDropdown(
        question: "10. Did the customer provide an incorrect shipping address intentionally? (গ্রাহক কি ইচ্ছাকৃতভাবে একটি ভুল শিপিং ঠিকানা প্রদান করেছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['incorrectAddress'] = value;
        },
      ),
      ReusableDropdown(
        question: "11. Did the customer return a product which is damaged or used that violated your return policy? (গ্রাহক কি এমন একটি পণ্য ফেরত দিয়েছেন যা ক্ষতিগ্রস্থ বা ব্যবহৃত হয়েছে, যা আপনার রিটার্ন নীতি লঙ্ঘন করেছে?)",
        hintText: "Select answer",
        options: [
          "Yes (হ্যাঁ)",
          "No, return issue was not the type of fraud I encountered (না, রিটার্ণ ইস্যুটি প্রতারণার কারন ছিলো না)"
        ],
        onChanged: (value) {
          formData['returnPolicyViolated'] = value;
        },
      ),
      ReusableDropdown(
        question: "12. Are there any specific policies related to refunds, returns, or address changes in your policy? (আপনার কি রিফান্ড, রিটার্ন বা ঠিকানা পরিবর্তন সম্পর্কিত কোনো নির্দিষ্ট নীতিমালা আছে?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['specificPolicies'] = value;
        },
      ),
      ReusableDropdown(
        question: "13. Have you communicated with the customer regarding the fraud issue? (আপনি কি গ্রাহকের সাথে প্রতারণার বিষয়টি সম্পর্কে যোগাযোগ করেছেন?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['communicated'] = value;
        },
      ),
      ReusableDropdown(
        question: "14. Do you have any evidence supporting your response to the complaint? (অভিযোগের প্রতি আপনার প্রতিক্রিয়া সমর্থন করে এমন কোনো প্রমাণ আছে কি?)",
        hintText: "Select answer",
        options: ["Yes (হ্যাঁ)", "No (না)"],
        onChanged: (value) {
          formData['evidence'] = value;
        },
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _submitForm,
        child: Text("Submit"),
      ),
    ];
  }
}
