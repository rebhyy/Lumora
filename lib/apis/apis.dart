import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translator_plus/translator_plus.dart';

import '../helper/global.dart';

class APIs {
  //get answer from google gemini ai
  /* static Future<String> getAnswer(String question) async {
    try {
      log('api key: $apiKey');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      log('res: ${res.text}');

      return res.text!;
    } catch (e) {
      log('getAnswerGeminiE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  } */

  static Future<String> getAnswer(String question) async {
    try {
      log('api key: $apiKey');

      // Ensure your apiKey is correctly set
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key is missing');
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),

        //headers
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $apiKey'
        },

        //body
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "max_tokens": 2000,
          "temperature": 0,
          "messages": [
            {"role": "user", "content": question},
          ]
        }),
      );

      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        final error = jsonDecode(response.body)['error'];
        return 'Error: ${error['message']}';
      }
    } catch (e) {
      log('getAnswerGptE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  static Future<List<String>> searchAiImages(String prompt) async {
    try {
      final response = await http.get(
        Uri.parse('https://lexica.art/api/v1/search?q=$prompt'),
      );

      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List.from(data['images'])
            .map((e) => e['src'].toString())
            .toList();
      } else {
        log('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      log('searchAiImagesE: $e');
      return [];
    }
  }

  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final res = await GoogleTranslator().translate(text, from: from, to: to);

      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }
}
