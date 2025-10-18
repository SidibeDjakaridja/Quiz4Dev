import 'dart:convert';
import 'dart:typed_data';

import '../../core/api/chatgpt_api.dart';
import '../../core/exceptions/gemini_exception.dart';
import '../../domain/entities/question.dart';
import '../models/question.dart';

class QuestionRemoteDataSource {
  const QuestionRemoteDataSource({
    required ChatGPTApi client,
  }) : _client = client;

  final ChatGPTApi _client;

  Future<List<Question>> getQuestions(String technology, String level) async {
    print('🟡 QuestionRemoteDataSource: Début du chargement des questions');
    print('🟡 Technologie: $technology');
    print('🟡 Niveau: $level');

    final prompt = '''
    Tu es un système qui aide les développeurs à se préparer aux entretiens d'embauche. Crée une liste de questions qui pourraient aider un développeur à réussir un entretien pour un $level poste dans $technology.
    Donne-moi 20 questions, dont 15 QCM (4 options maximum par question mais une option doit être correcte par question) et 5 petites questions à répondre, le tout dans un seul bloc.
    Donnez votre réponse dans ce qui suit format(JSON): {"questions": [{"label":"", "answers":[{"label":"", "isCorrect":false},{"label":"", "isCorrect":true}]}]}. Pour répondre aux 5 questions, tu dois avoir "answers": [].
    Ne renvoie pas le résultat sous forme de Markdown.
    ''';
    try {
      print('🟡 QuestionRemoteDataSource: Envoi de la requête à ChatGPT...');
      final response = await _client.generateContent(prompt);

      if (response == null) {
        print('🔴 QuestionRemoteDataSource: La réponse de ChatGPT est vide');
        throw const GeminiException('La réponse est vide');
      }

      print('🟡 QuestionRemoteDataSource: Réponse reçue, nettoyage du JSON...');
      String cleanedResponse = response.replaceAll(RegExp(r'```json\n*'), '');
      cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```'), '');
      cleanedResponse = cleanedResponse.trim();

      print('🟡 QuestionRemoteDataSource: JSON nettoyé: $cleanedResponse');

      try {
        final jsonData = jsonDecode(cleanedResponse);
        if (jsonData is Map<String, dynamic> && jsonData['questions'] is List) {
          final questions = jsonData['questions'] as List<dynamic>;
          print(
              '🟡 QuestionRemoteDataSource: Parsing réussi, ${questions.length} questions trouvées');
          return questions.map((json) => QuestionModel.fromJson(json)).toList();
        } else {
          print('🔴 QuestionRemoteDataSource: Structure JSON invalide');
          throw const GeminiException('Invalid JSON structure');
        }
      } catch (e) {
        print('🔴 QuestionRemoteDataSource: Erreur de parsing JSON: $e');
        print('🔴 JSON problématique: $cleanedResponse');
        throw GeminiException('Erreur de parsing JSON: $e');
      }
    } catch (e) {
      if (e is GeminiException) rethrow;

      print('Erreur dans QuestionRemoteDataSource.getQuestions: $e');
      throw GeminiException('Erreur lors de la génération des questions: $e');
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

      try {
        final jsonData = jsonDecode(cleanedResponse);
        if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('isCorrect') &&
            jsonData.containsKey('answer')) {
          final isCorrect = jsonData['isCorrect'] == true;
          final answer = jsonData['answer']?.toString() ?? '';
          return (isCorrect, answer);
        } else {
          print(
              '🔴 QuestionRemoteDataSource: Structure JSON invalide pour validation');
          throw const GeminiException('Invalid JSON structure for validation');
        }
      } catch (e) {
        print(
            '🔴 QuestionRemoteDataSource: Erreur de parsing JSON pour validation: $e');
        print('🔴 JSON problématique: $cleanedResponse');
        throw GeminiException('Erreur de parsing JSON pour validation: $e');
      }
    } catch (e) {
      if (e is GeminiException) rethrow;

      print('Erreur dans QuestionRemoteDataSource.validateQuestion: $e');
      throw GeminiException('Erreur lors de la validation de la question: $e');
    }
  }
}
