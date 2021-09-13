import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../model/reports_model.dart';
import 'native_pdf_preview.dart';

class NativePdfPayload extends StatefulWidget {
  //loading data from assets
  @override
  _NativePdfPayloadState createState() => _NativePdfPayloadState();
}

class _NativePdfPayloadState extends State<NativePdfPayload> {
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

  savetoApplicationDirectory() async {
    await fetchReports();
    await writePdf();
    await saveNopenPdf();
  }

  @override
  void initState() {
    super.initState();
    savetoApplicationDirectory();
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

  Future saveNopenPdf() async {
    try {
      String report = "Report-";
      String date = "13-09-2021";
      String concatReportDate = report + date;

      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;

      File file = File("$documentPath/$concatReportDate.pdf");
      file.writeAsBytesSync(await pdf.save());

      String fullPath = "$documentPath/$concatReportDate.pdf";
      print(fullPath);

      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NativePdfPreviewScreen(path: fullPath),
      ));
    } catch (e) {
      print("Exception thrown : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
