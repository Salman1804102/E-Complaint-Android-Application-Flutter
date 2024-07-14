import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/services.dart';
class EcommerceRules2021 extends StatefulWidget {
  const EcommerceRules2021({super.key});

  @override
  State<EcommerceRules2021> createState() => _EcommerceRules2021State();
}

String url = 'assets/pdf/law.pdf';

class _EcommerceRules2021State extends State<EcommerceRules2021> {

  final _pdfController = PdfController(
    document: PdfDocument.openAsset(url),
  );

  Future loadPdf() async {
    try {
      await rootBundle.load(url);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Widget loaderWidget = const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
    return Scaffold(
      body: SafeArea(
          child: Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.height,
            child: _pdfController == null
                ? loaderWidget
                : PdfView(
                controller: _pdfController),
          )),
    );
  }
}
