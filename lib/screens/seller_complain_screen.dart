import 'package:flutter/material.dart';

class SellerComplainScreen extends StatelessWidget {
  const SellerComplainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complain Against Seller"),
      ),
      body: Center(
        child: const Text("Complain Against Seller Page"),
      ),
    );
  }
}
