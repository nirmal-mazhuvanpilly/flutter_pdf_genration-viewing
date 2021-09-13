import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class NativePdfPreviewScreen extends StatefulWidget {
  final String path;
  NativePdfPreviewScreen({this.path});

  @override
  _NativePdfPreviewScreenState createState() => _NativePdfPreviewScreenState();
}

class _NativePdfPreviewScreenState extends State<NativePdfPreviewScreen> {
  PdfController pdfController;

  @override
  void initState() {
    super.initState();
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.path),
      initialPage: 1,
      viewportFraction: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Native Preview"),
      ),
      body: PdfView(
        controller: pdfController,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
