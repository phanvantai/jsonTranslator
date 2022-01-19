import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:path_provider/path_provider.dart';

class Translator {
  static Future<String> handleFile(
      File file, String apiKey, String outputFileName) async {
    Future<Directory?>? _externalDocumentsDirectory;
    Future<List<Directory>?>? _externalStorageDirectories;
    int count = 0;
    _externalDocumentsDirectory = getExternalStorageDirectory();
    print(_externalDocumentsDirectory);
    _externalStorageDirectories =
        getExternalStorageDirectories(type: StorageDirectory.downloads);
    print(_externalStorageDirectories);
    return file.readAsLines().then((value) async {
      for (var element in value) {
        if (element.contains(':')) {
          var abc = element.split(':');
          if (abc.length > 1 && abc[1].contains('"')) {
            if (count == 10) {
              // delay to avoid request to much in a limited time
              await Future.delayed(const Duration(milliseconds: 800));
              count = 0;
            }
            //var translated =
            //    abc[1]; //await translate(apiKey, outputFileName, abc[1]);
            count += 1;
            //var newElement = abc[0] + ':' + translated;

            /// write new element to a line new file
          } else {
            /// write element to a line new file
          }
        } else {
          /// write element to a line new file
        }
      }
      return 'mnpq';
    }).catchError((error) {
      return error.toString();
    });
  }

  static Future<String> translate(
      String apiKey, String targetLanguage, String message) async {
    final response = await http.post(
      Uri.parse(
          'https://translation.googleapis.com/language/translate/v2?target=$targetLanguage&key=$apiKey&q=$message'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final translations = body['data']['translations'] as List;
      final translation = translations.first;

      return HtmlUnescape().convert(translation['translatedText']);
    } else {
      throw Exception();
    }
  }
}
