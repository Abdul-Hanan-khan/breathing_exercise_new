import 'package:breathing_exercise_new/models/posts_modal.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import 'package:pdf_flutter/pdf_flutter.dart';

class ViewDocumentScreen extends StatefulWidget {
  String title;
String pdfUrl;
  ViewDocumentScreen(this.title,this.pdfUrl);
  @override
  _ViewDocumentScreenState createState() => _ViewDocumentScreenState();
}

class _ViewDocumentScreenState extends State<ViewDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.GREEN_ACCENT,
        title: Text(widget.title ?? 'Reading is Awesome'),
        centerTitle: true,
      ),
      body:Container(
          child: SfPdfViewer.network(
            widget.pdfUrl,
            key: _pdfViewerKey,
          )

      ),
    );
  }
}
