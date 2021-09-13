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

  int actualPageNumber = 1, allPagesCount = 0;

  @override
  void initState() {
    super.initState();
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.path),
      initialPage: 1,
      viewportFraction: 0.80,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Native Preview"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_circle_down),
                    onPressed: () {
                      if (actualPageNumber < allPagesCount)
                        pdfController.jumpToPage(actualPageNumber + 1);
                    }),
                IconButton(
                    icon: Icon(Icons.arrow_circle_up_outlined),
                    onPressed: () {
                      if (actualPageNumber > 1)
                        pdfController.jumpToPage(actualPageNumber - 1);
                    }),
                Text(actualPageNumber.toString()),
                Text("/"),
                Text(allPagesCount.toString()),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black87,
              child: PdfView(
                controller: pdfController,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                onDocumentLoaded: (document) {
                  setState(() {
                    allPagesCount = document.pagesCount;
                    print(allPagesCount);
                  });
                },
                onPageChanged: (page) {
                  setState(() {
                    actualPageNumber = page;
                    print(actualPageNumber);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
