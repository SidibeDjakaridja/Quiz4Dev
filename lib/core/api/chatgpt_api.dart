import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatGPTApi {
  final String _apiKey;
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  ChatGPTApi() : _apiKey = dotenv.get("OPENAI_API_KEY") {
    if (_apiKey.isEmpty || _apiKey == "YOUR_OPENAI_API_KEY_HERE") {
      print('🔴 ERREUR: Clé API OpenAI non configurée ou invalide!');
      print('🔴 Veuillez configurer votre clé API dans assets/env/.env');
    } else {
      print(
          '🔵 OpenAI API: Initialisation avec la clé ${_apiKey.substring(0, 10)}...');
    }
  }

  Future<String?> generateContent(String prompt) async {
    try {
      print('🔵 ChatGPT API: Envoi de la requête...');
      print('🔵 Prompt: $prompt');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: utf8.encode(jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 4000,
          'temperature': 0.7,
        })),
      );

      if (response.statusCode == 200) {
        // Décoder la réponse avec UTF-8 pour gérer les caractères spéciaux
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        final content = data['choices'][0]['message']['content'];

        print('🔵 ChatGPT API: Réponse reçue');
        print('🔵 Réponse: $content');

        return content;
      } else {
        print('🔴 Erreur HTTP: ${response.statusCode}');
        print('🔴 Réponse: ${utf8.decode(response.bodyBytes)}');
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Erreur ChatGPT API: $e');
      rethrow;
    }
  }

  Future<String?> generateContentWithImage(
      String prompt, Uint8List file, String type) async {
    try {
      print('🔵 ChatGPT API: Envoi de la requête avec fichier...');
      print('🔵 Prompt: $prompt');
      print('🔵 Type de fichier: $type');

      // Pour l'instant, on ignore le fichier et on traite juste le texte
      // TODO: Implémenter la gestion des fichiers audio si nécessaire

      return await generateContent(prompt);
    } catch (e) {
      print('🔴 Erreur ChatGPT API avec fichier: $e');
      rethrow;
    }
  }
}
