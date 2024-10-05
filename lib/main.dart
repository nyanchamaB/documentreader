import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusionPdf;
import 'package:pdf_render/pdf_render.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _pdfText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Reader & Text Extractor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickPdf,
              child: Text('Pick PDF'),
            ),
            SizedBox(height: 20),
            _pdfText != null
                ? Text(_pdfText ?? "No text extracted")
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes != null) {
        // Use Syncfusion PdfDocument to load the PDF
        syncfusionPdf.PdfDocument document =
            syncfusionPdf.PdfDocument(inputBytes: fileBytes);

        // Extract text from the first page
        String extractedText =
            syncfusionPdf.PdfTextExtractor(document).extractText();
        setState(() {
          _pdfText = extractedText;
        });

        document.dispose(); // Dispose of the document after use
      }
    }
  }
}
