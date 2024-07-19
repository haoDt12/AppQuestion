import 'dart:convert';
import 'package:quizz/model/category.dart';
import 'package:http/http.dart' as http;

class CategoryApi {
  static Future<Category> fetchCategories() async {
    const url = 'https://opentdb.com/api_category.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }
}