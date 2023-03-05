import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';


class PDf extends StatefulWidget {
  final path;
  final name;
  const PDf({super.key, this.path, this.name});
  @override
  State<PDf> createState() => _PDfState(path : path, name : name);
}

class _PDfState extends State<PDf> {
  final path;
  final name;
  _PDfState({required this.name,required this.path});

  PDFDocument? document;
  bool loading = true;

  loadDocument() async {
    document = await PDFDocument.fromURL(path);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDocument();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name)),
        body: Center(
            child:
            loading ?
            const CircularProgressIndicator()
                :
            PDFViewer(
              document: document!,
            )
        )
    );
  }
}
