import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String pdfpath;
  PdfPreviewScreen({this.pdfpath});

  Future<void> shareData() async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;

      String fullPath = "$documentPath/Report.pdf";
      print(fullPath);
      Share.shareFiles([fullPath], text: 'Joy Alukkas EGP Report');
    } catch (e) {
      print("Exception thrown : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("EGP Report"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: shareData,
          ),
        ],
      ),
      path: pdfpath,
    );
  }
}
