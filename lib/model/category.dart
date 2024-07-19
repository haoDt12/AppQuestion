import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  List<TriviaCategory> triviaCategories;

  Category({
    required this.triviaCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    triviaCategories: List<TriviaCategory>.from(json["trivia_categories"].map((x) => TriviaCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "trivia_categories": List<dynamic>.from(triviaCategories.map((x) => x.toJson())),
  };
}

class TriviaCategory {
  int id;
  String name;

  TriviaCategory({
    required this.id,
    required this.name,
  });

  factory TriviaCategory.fromJson(Map<String, dynamic> json) => TriviaCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}