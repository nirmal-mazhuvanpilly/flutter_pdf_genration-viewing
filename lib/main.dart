import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdf/pdf_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import './reports_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  //loading data from assets
  Future<ReportsModel> loadReports() async {
    String data = await rootBundle.loadString("assets/report.json");
    var res = json.decode(data);
    var reports = ReportsModel.fromJson(res);
    return reports;
  }

  ReportsModel _reportsModel = ReportsModel();

  ReportsModel get reportModel => _reportsModel;

  set reportModel(ReportsModel reportsModel) {
    _reportsModel = reportsModel;
  }

  fetchReports() async {
    reportModel = await loadReports();
  }

  @override
  void initState() {
    super.initState();

    fetchReports();
  }

  final pdf = pw.Document();

  Future writePdf() async {
    pdf.addPage(
      pw.MultiPage(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text("Joy Alukkas EGP - Report", textScaleFactor: 2),
                  pw.Text("06/09/2021", textScaleFactor: 2),
                ],
              ),
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table(
              border: pw.TableBorder.all(
                width: 1,
                color: PdfColors.black,
                style: pw.BorderStyle.solid,
              ),
              children: <pw.TableRow>[
                pw.TableRow(children: <pw.Widget>[
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Sl No.")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("EGP Card No.")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Mobile No.")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Payment Mode")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Total Paid")),
                ]),
                for (int index = 0; index < reportModel.data.length; index++)
                  pw.TableRow(children: <pw.Widget>[
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("${index + 1}")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(reportModel.data
                            .elementAt(index)
                            .egpCardNo
                            .toString())),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(reportModel.data
                            .elementAt(index)
                            .mobile
                            .toString())),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(reportModel.data
                            .elementAt(index)
                            .paymentMode
                            .toString())),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(reportModel.data
                            .elementAt(index)
                            .totalPaid
                            .toString())),
                  ]),
              ],
            ),
          ];
        },
      ),
    );
  }

  Future saveNopenPdf(BuildContext context) async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      File file = File("$documentPath/example.pdf");
      file.writeAsBytesSync(await pdf.save());

      String fullPath = "$documentPath/example.pdf";
      print(fullPath);

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfPreviewScreen(
                    pdfpath: fullPath,
                  )));
    } catch (e) {
      print("Exception thrown : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Colors.blueGrey,
              child: Text(
                'Preview PDF',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              onPressed: () async {
                try {
                  await writePdf();
                  await saveNopenPdf(context);
                } catch (e) {
                  print("Exception thrown : $e");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
