import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  final String fileURL;
  const PDFViewer({super.key, required this.fileURL});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              child: SfPdfViewer.network(
                  widget.fileURL,scrollDirection: PdfScrollDirection.horizontal,pageLayoutMode: PdfPageLayoutMode.single))),
    );
  }
}
