import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertest/utils/color_utils.dart';

class LawyerPage extends StatelessWidget {
  LawyerPage({Key? key}) : super(key: key);
  final List<Lawyer> lawyers = [
    Lawyer(
      name: 'MD Sohel Rana',
      title: 'Advocate',
      court: 'Supreme Court of Bangladesh',
      about: 'এডভোকেট সোহেল রানা এল এল.বি (অনার্স), এল এল.এম (EU) বিগত ১০ বৎসর যাবত আইন পেশায় নিয়োজিত আছেন । কাজ করেছি ৪০০ এর অধিক কেইস নিয়ে যেখানে সফলতার হার ছিল ৮০ শতাংশেরও বেশী। পরবর্তীতে ল ফার্ম এস এন এস অ্যাসোসিএটস এর কর্ণধার হিসেবে যাত্রা শুরু করেন',
      chambers: [
        'জজকোর্ট চেম্বার\nপারজোয়ার সেন্টার, রুম # এফ ১৩, ৫ম তলা\n২২ নং কোর্ট হাউস স্ট্রিট, কোতোয়ালি ঢাকা ১১০০',
        'সান্ধ্যকালীন চেম্বার\nSuit G, 12th Floor, Tropikana Tower\n45 Topkhana Road, Purana Paltan, Dhaka - 1000'
      ],
      phoneNumber: '01712345678',
      imgURL: 'assets/images/sohelRana.png',
    ),
    Lawyer(
      name: 'Syed Bazlul Kibria',
      title: 'Advocate',
      about: 'Syed Bazlul Kibria is a renowned advocate with diverse skills in vetting and drafting agreements. With extensive knowledge in various legal domains, including land, civil and criminal cases, VAT and tax matters, and intellectual property rights, he ensures compliance and provides comprehensive legal support to clients.',
      court: 'Dhaka Judge Court',
      chambers: [
        'Chamber Address: 124/1, 1 East Raja Bazar, She-E-Bangla Nagar, Dhaka - 1207'
      ],
      phoneNumber: '01308383801',
      email: 'info@lacsb.com',
      imgURL: 'assets/images/syed_bazlul_kibria.png'
    ),
    Lawyer(
      name: 'Mohammad Noore Alam',
      title: 'Advocate',
      about: 'Mohammad Noore Alam Babu is a highly acclaimed criminal lawyer known for his exceptional legal expertise in Dhaka Judge Court. With a strong track record of successfully defending clients in complex criminal cases, his strategic approach, sharp analytical skills, and unwavering dedication have earned him a stellar reputation at Dhaka Judge Court.',
      court: 'Dhaka Judge Court',
      chambers: [
        'Chamber Address: Dhaka Lawyers Association Building, Room No. 12, Level - 4, 6 - 7 Court House Street, Kotwalli, Dhaka - 1100'
      ],
      phoneNumber: '01798765432',
      imgURL: 'assets/images/mohammed_nore_alam.png'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lawyer Directory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: lawyers.length,
          itemBuilder: (context, index) {
            return LawyerCard(lawyer: lawyers[index]);
          },
        ),
      ),
    );
  }
}

class Lawyer {
  final String name;
  final String title;
  final String about;
  final String court;
  final List<String> chambers;
  final String phoneNumber;
  final String? email;
  final String imgURL;

  Lawyer({
    required this.name,
    required this.title,
    required this.about,
    required this.court,
    required this.chambers,
    required this.phoneNumber,
    required this.imgURL,
    this.email,
  });
}

class LawyerCard extends StatefulWidget {
  final Lawyer lawyer;

  LawyerCard({required this.lawyer});

  @override
  _LawyerCardState createState() => _LawyerCardState();
}

class _LawyerCardState extends State<LawyerCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        isExpanded = !isExpanded;
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isExpanded ? 300 : 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.lawyer.imgURL),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lawyer.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(widget.lawyer.title),
                    SizedBox(height: 5),
                    Text(widget.lawyer.court),
                    SizedBox(height: 10),
                    Text(
                      widget.lawyer.about,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    if (isExpanded) ...[
                      SizedBox(height: 10),
                      ...widget.lawyer.chambers.map((chamber) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(chamber),
                      )),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _launchPhone(widget.lawyer.phoneNumber);
                        },
                        child: Text('Contact Lawyer'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}