import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ATSScreen extends StatefulWidget {
  static const String routeName = '/ats-screen';

  @override
  _ATSScreenState createState() => _ATSScreenState();
}

class _ATSScreenState extends State<ATSScreen> {
  File? _cvFile;
  String? _result;
  String? _downloadUrl;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      setState(() {
        _cvFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _analyzeCV() async {
    if (_cvFile == null) return;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/analyze_cv')
    );
    request.files.add(await http.MultipartFile.fromPath('file', _cvFile!.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    setState(() {
      _result = responseBody.contains("Not ATS") ? "Not ATS Compliant" : "ATS Compliant";
      if (responseBody.contains("Not ATS")) {
        _downloadUrl = "http://127.0.0.1:8000/download_ats_cv";
      }
    });
  }

  Future<void> _downloadCV() async {
    if (_downloadUrl == null) return;

    var response = await http.get(Uri.parse(_downloadUrl!));
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/ATS_CV.pdf');
    await file.writeAsBytes(response.bodyBytes);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloaded to ${file.path}")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ATS CV Analyzer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_cvFile != null) Text("Selected File: ${_cvFile!.path}"),
            ElevatedButton(onPressed: _pickFile, child: Text("Upload CV")),
            if (_result != null) Text("Result: $_result", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_downloadUrl != null)
              ElevatedButton(onPressed: _downloadCV, child: Text("Download ATS CV")),
          ],
        ),
      ),
    );
  }
}
