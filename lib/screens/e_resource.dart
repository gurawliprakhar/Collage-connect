import 'dart:io';
import 'package:alpha/screens/pdf_viewer.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EResource extends StatefulWidget {
  const EResource({Key? key}) : super(key: key);

  @override
  State<EResource> createState() => _EResourceState();
}

class _EResourceState extends State<EResource> {
  final storage = FirebaseStorage.instance;

  Future<void> uploadPDF(String fileName, String filePath, context) async {
    File file = File(filePath);
    try {
      await storage.ref('PDFs/$fileName').putFile(file);
      showInSnackBar(value: 'Pdf uploaded successfully', context: context);
    } catch (e) {}
  }

  Future<ListResult> listFiles() async {
    ListResult listResult = await storage.ref("PDFs").listAll();
    return listResult;
  }

  static Future<File> loadFirebase(String url) async {
    var bytes;
    try {
      final refPDF = FirebaseStorage.instance.ref().child('PDFs/$url');
      bytes = await refPDF.getData();
      // print(bytes);
    } catch (e) {}

    return _storeFile(url, bytes as List<int>);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  void openPDF(BuildContext context, File file) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => PDFViewerPage(
            file: file,
          ),
        ),
      );

  void showInSnackBar({required String value, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: Colors.white)),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.fixed,
      elevation: 5.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Resource'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.any,
          );
          if (result == null) {
            print("No file selected");
          } else {
            final filePath = result.files.single.path;
            final fileName = result.files.single.name;
            uploadPDF(fileName, filePath!, context);
          }
        },
      ),
      body: Center(
        child: FutureBuilder(
          future: listFiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Image.asset(
                              "assets/pdf.png",
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              snapshot.data!.items[index].name,
                              style: const TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20, bottom: 8),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: TextButton(
                              onPressed: () async {
                                final url = snapshot.data!.items[index].name;
                                print(url);
                                final file = await loadFirebase(url);

                                if (file == null) {
                                  return;
                                }
                                openPDF(context, file);
                              },
                              child: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          thickness: 2,
                        )
                      ],
                    );
                  });
            }
            return const Text('Error!!!');
          },
        ),
      ),
    );
  }
}
