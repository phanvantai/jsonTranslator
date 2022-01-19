import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:json_translator/localization_helper.dart';
import 'package:json_translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Tranlator Tool',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Json Translator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? pickedFile;
  String outputFileName = '';
  String outputFilePath = '';
  String apiKey = '';

  final controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            allowedExtensions: ['json'], type: FileType.custom);

                    if (result?.files.single.path != null) {
                      setState(() {
                        pickedFile = File(result!.files.single.path!);
                      });
                      debugPrint('taipv file $pickedFile path');
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text('Pick a file need to be translate'),
                ),
                pickedFile != null
                    ? Text('Picked file: $pickedFile')
                    : const SizedBox.shrink(),
                const SizedBox(height: 24),
                const Text(
                  'Paste API key to below:',
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 300,
                  child: TextFormField(
                    controller: controller,
                    onChanged: (value) {
                      setState(() {
                        apiKey = value;
                      });
                    },
                  ),
                ),
                _dropDown(),
                outputFileName.isNotEmpty
                    ? Text('Ouput File Name: $outputFileName.json')
                    : const SizedBox.shrink(),
                const SizedBox(height: 24),
                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: apiKey.length < 39 ||
                                pickedFile == null ||
                                outputFileName.isEmpty
                            ? null
                            : () async {
                                setState(() {
                                  loading = true;
                                });
                                var result = await Translator.handleFile(
                                    pickedFile!, apiKey, outputFileName);
                                setState(() {
                                  loading = false;
                                  outputFilePath = result;
                                });
                              },
                        child: const Text('Create translated file'),
                      ),
                outputFilePath.isNotEmpty
                    ? Text("output File: $outputFilePath")
                    : const SizedBox.shrink(),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ],
    );
  }

  _dropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
      child: DropdownButtonFormField(
        hint: Text(
          'Choose lange to translate to',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.5)),
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: Colors.white,
        onChanged: (newValue) {
          var choosenLanguage = LocalizationHelper.values
              .where((element) {
                return element.stringLocale == newValue as String;
              })
              .map((e) => e.stringLocale)
              .toList()
              .first;
          setState(() {
            outputFileName = choosenLanguage;
          });
        },
        items: LocalizationHelper.values
            .map((e) => DropdownMenuItem(
                  value: e.stringLocale,
                  child: Container(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      e.stringLocale,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
