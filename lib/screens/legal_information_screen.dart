import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:fluttertest/utils/color_utils.dart'; // Import your color utility if needed
import 'package:fluttertest/screens/ecommerce_rules_2021.dart';
class LegalInformationScreen extends StatelessWidget {
  const LegalInformationScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> legalInfo = const [
    {
      "heading": "ধার্য্যকৃত মূল্যের অধিক মূল্যে পণ্য, ঔষধ বা সেবা বিক্রয় করিবার দণ্ড",
      "content": "৪০৷ কোন ব্যক্তি কোন আইন বা বিধির অধীন নির্ধারিত মূল্য অপেক্ষা অধিক মূল্যে কোন পণ্য, ঔষধ বা সেবা বিক্রয় বা বিক্রয়ের প্রস্তাব করিলে তিনি অনূর্ধ্ব এক বৎসর কারাদণ্ড, বা অনধিক পঞ্চাশ হাজার টাকা অর্থদণ্ড, বা উভয় দণ্ডে দণ্ডিত হইবেন।"
    },
    {
      "heading": "ভেজাল পণ্য বা ঔষধ বিক্রয়ের দণ্ড",
      "content": "৪৪৷ কোন ব্যক্তি জ্ঞাতসারে ভেজাল মিশ্রিত পণ্য বা ঔষধ বিক্রয় করিলে বা করিতে প্রস্তাব করিলে তিনি অনূর্ধ্ব তিন বৎসর কারাদণ্ড, বা অনধিক দুই লক্ষ টাকা অর্থদণ্ড, বা উভয় দণ্ডে দণ্ডিত হইবেন।"
    },
    {
      "heading": "মিথ্যা বিজ্ঞাপন দ্বারা ক্রেতা সাধারণকে প্রতারিত করিবার দণ্ড৷",
      "content": "৪৪৷ কোন ব্যক্তি কোন পণ্য বা সেবা বিক্রয়ের উদ্দেশ্যে অসত্য বা মিথ্যা বিজ্ঞাপন দ্বারা ক্রেতা সাধারণকে প্রতারিত করিলে তিনি অনূর্ধ্ব এক বৎসর কারাদণ্ড, বা অনধিক দুই লক্ষ টাকা অর্থদণ্ড, বা উভয় দণ্ডে দণ্ডিত হইবেন।"
    },
    {
      "heading": "প্রতিশ্রুত পণ্য বা সেবা যথাযথভাবে বিক্রয় বা সরবরাহ না করিবার দণ্ড",
      "content": "৪৫৷ কোন ব্যক্তি প্রদত্ত মূল্যের বিনিময়ে প্রতিশ্রুত পণ্য বা সেবা যথাযথভাবে বিক্রয় বা সরবরাহ না করিলে তিনি অনূর্ধ্ব এক বৎসর কারাদণ্ড, বা অনধিক পঞ্চাশ হাজার টাকা অর্থদণ্ড, বা উভয় দণ্ডে দণ্ডিত হইবেন।"
    },
    {
      "heading": "পণ্যের নকল প্রস্তুত বা উৎপাদন করিবার দণ্ড",
      "content": "৫০৷ কোন ব্যক্তি কোন পণ্যের নকল প্রস্তুত বা উৎপাদন করিলে তিনি অনূর্ধ্ব তিন বৎসর কারাদণ্ড, বা অনধিক দুই লক্ষ টাকা অর্থদণ্ড, বা উভয় দণ্ডে দণ্ডিত হইবেন।"
    },
    {
      "heading": "মেয়াদ উত্তীর্ণ কোন পণ্য বা ঔষধ বিক্রয় করিবার দণ্ড",
      "content": "৫১৷ কোন ব্যক্তি মেয়াদ উত্তীর্ণ কোন পণ্য বা ঔষধ বিক্রয় করিলে বা করিতে প্রস্তাব করিলে তিনি অনূর্ধ্ব এক বৎসর কারাদণ্ড, বা অনধিক পঞ্চাশ হাজার টাকা অর্থদণ্ড, বা উভয় দণ্ডে দণ্ডিত হইবেন।"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Legal Information"),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: legalInfo.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withOpacity(0.9),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              legalInfo[index]['heading']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              legalInfo[index]['content']!,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EcommerceRules2021()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // background color
                      foregroundColor: Colors.white, // text color
                      elevation: 5, // button's elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // button's shape
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.1,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Download E-commerce Rules 2021"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> launch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<bool> canLaunch(String url) async {
  return await canLaunchUrl(Uri.parse(url));
}
