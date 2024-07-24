import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../core/api/gemini_api.dart';
import '../../core/exceptions/gemini_exception.dart';
import '../../domain/entities/question.dart';
import '../models/question.dart';

class QuestionRemoteDataSource {
  const QuestionRemoteDataSource({
    required GeminiApi client,
  }) : _client = client;

  final GeminiApi _client;

  Future<List<Question>> getQuestions(String technology, String level) async {
    final prompt = '''
    Tu es un système qui aide les développeurs à se préparer aux entretiens d'embauche. Crée une liste de questions qui pourraient aider un développeur à réussir un entretien pour un $level poste dans $technology.
    Donne-moi 20 questions, dont 15 QCM (4 options maximum par question mais une option doit être correcte par question) et 5 petites questions à répondre, le tout dans un seul bloc.
    Donnez votre réponse dans ce qui suit format(JSON): {"questions": [{"label":"", "answers":[{"label":"", "isCorrect":false},{"label":"", "isCorrect":true}]}]}. Pour répondre aux 5 questions, tu dois avoir "answers": [].
    Ne renvoie pas le résultat sous forme de Markdown.
    ''';
    try {
      final response = await _client.generateContent(prompt);

      if (response == null) {
        throw const GeminiException('La réponse est vide');
      }
      String cleanedResponse = response.replaceAll(RegExp(r'```json\n*'), '');
      cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```'), '');
      if (jsonDecode(cleanedResponse)
          case {'questions': List<dynamic> questions}) {
        return questions.map((json) => QuestionModel.fromJson(json)).toList();
      }

      throw const GeminiException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminiException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminiException) rethrow;

      throw const GeminiException();
    }
  }

  Future<(bool, String)> validateQuestion(String question,
      {String? answer, Uint8List? file}) async {
    final prompt = file == null
        ? '''
    Tu es un système qui aide les développeurs à se préparer aux entretiens d'embauche.
    Vérifiez si la réponse à la question suivante est correcte.
    La question est : $question.
    La réponse est : $answer.
    Fournis ta réponse au format suivant : {"isCorrect": true/false, "answer": ""}.
    Si c'est partiellement correct, renvoie vrai mais fournit plus d'informations.
    Si c'est faux, fournis la réponse à cette question. (Pas plus de 200 mots pour la réponse)
    Ne renvoie pas le résultat sous forme de Markdown.
    '''
        : '''
    Tu es un système qui aide les développeurs à se préparer aux entretiens d'embauche.
    Vérifiez si la réponse à la question suivante est correcte.
    La question est : $question.
    Nous te remettons un fichier audio qui contient la réponse.
    Fournis ta réponse au format suivant : {"isCorrect": true/false, "answer": ""}.
    Si c'est partiellement correct, renvoie vrai mais fournit plus d'informations.
    Si c'est faux, fournis la réponse à cette question. (Pas plus de 200 mots pour la réponse)
    Ne renvoie pas le résultat sous forme de Markdown.
    ''';
    try {
      final response = file == null
          ? await _client.generateContent(prompt)
          : await _client.generateContentWithImage(prompt, file, 'audio/mp3');

      if (response == null) {
        throw const GeminiException('La réponse est vide');
      }
      String cleanedResponse = response.replaceAll(RegExp(r'```json\n*'), '');
      cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```'), '');

      if (jsonDecode(cleanedResponse)
          case {'isCorrect': bool isCorrect, 'answer': String answer}) {
        return (isCorrect, answer);
      }

      throw const GeminiException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminiException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminiException) rethrow;

      throw const GeminiException();
    }
  }
}
