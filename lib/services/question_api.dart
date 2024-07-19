import 'dart:convert';

import 'package:quizz/model/question.dart';
import 'package:http/http.dart' as http;
class QuestionApi{
  static Future<Question> fetchQuestions(int categoryId) async{
    final url = 'https://opentdb.com/api.php?amount=10&category=$categoryId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return questionFromJson(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }
}