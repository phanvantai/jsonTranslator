import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class Translator {
  static Future<String> handleFile(
      File file, String apiKey, String outputFileName) async {
    int count = 0;
    // path for android emulator
    var newFile =
        File('/storage/emulated/0/Download/' + outputFileName + '.json');
    return file.readAsLines().then((value) async {
      for (var element in value) {
        if (element.contains(':')) {
          var abc = element.split(':');
          if (abc.length > 1 && abc[1].contains('"')) {
            if (count == 10) {
              // delay to avoid request to much in a limited time
              await Future.delayed(const Duration(milliseconds: 500));
              count = 0;
            }
            var translated = await translate(apiKey, outputFileName, abc[1]);
            count += 1;
            var newElement = abc[0] + ':' + translated + '\n';
            newFile.writeAsStringSync(newElement, mode: FileMode.append);
          } else {
            newFile.writeAsStringSync(element + '\n', mode: FileMode.append);
          }
        } else {
          newFile.writeAsStringSync(element + '\n', mode: FileMode.append);
        }
      }
      return newFile.path;
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
