import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String pdfpath;
  PdfPreviewScreen({this.pdfpath});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: pdfpath,
    );
  }
}
