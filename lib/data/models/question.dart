import 'package:prep_for_dev/domain/entities/answer.dart';

import '../../domain/entities/question.dart';
import 'answer.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.label,
    required super.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = [];

    // Gérer le cas où answers peut être null ou vide
    if (json['answers'] != null && json['answers'] is List) {
      for (var item in json['answers']) {
        if (item != null) {
          answers.add(AnswerModel.fromJson(item));
        }
      }
      answers.shuffle();
    }

    return QuestionModel(
      label: json['label']?.toString() ?? '',
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'answers': answers,
    };
  }
}
