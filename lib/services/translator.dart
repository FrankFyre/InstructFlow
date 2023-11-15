import 'dart:convert';
import 'package:http/http.dart' as http;

translator(language, text) async {
  const apiKey = "AIzaSyA_2_6zv9Mp9wq2RKC2a8i8YMerchO4DiQ";
  String to = language;

  final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?q=$text&target=$to&key=$apiKey');

  final response = await http.post(url);

  if (response.statusCode == 200) {
    final body = json.decode(response.body);

    final translations = body['data']['translations'] as List;

    return translations.first['translatedText'];
  } else {
    return text;
  }
}



//    - zh-CN 
    // - ms
    // - ta
    // - id
    // - hi
