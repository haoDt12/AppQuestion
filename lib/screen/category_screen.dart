import 'package:flutter/material.dart';
import 'package:quizz/screen/question_screen.dart';
import 'package:quizz/services/category_api.dart';
import 'package:quizz/model/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<CategoryScreen> {
  late Future<Category> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryApi.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      body: FutureBuilder<Category>(
        future: futureCategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(snapshot.data!.triviaCategories.length,
                  (index) {
                final category = snapshot.data!.triviaCategories[index];
                return Card(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  color: Colors.purple,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    // Ensure the border radius matches the Card's
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionScreen(categoryId:category.id,categoryName:category.name),
                          ),
                        );
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getCategoryIcon(category.name),
                              // Lấy icon tương ứng
                              size: 30.0,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'General Knowledge':
        return Icons.public;
      case 'Entertainment: Books':
        return Icons.menu_book_sharp;
      case 'Entertainment: Film':
        return Icons.movie;
      case 'Entertainment: Music':
        return Icons.library_music;
      case 'Entertainment: Musicals & Theatres':
        return Icons.theaters_rounded;
      case 'Entertainment: Television':
        return Icons.live_tv_outlined;
      case 'Entertainment: Video Games':
        return Icons.videogame_asset_outlined;
      case 'Entertainment: Board Games':
        return Icons.dashboard_customize_outlined;
      case 'Science & Nature':
        return Icons.nature;
      case 'Science: Computers':
        return Icons.memory;
      case 'Sports':
        return Icons.sports_martial_arts;
      case 'Geography':
        return Icons.golf_course_outlined;
      case 'History':
        return Icons.history;
      case 'Politics':
        return Icons.account_balance;
      case 'Art':
        return Icons.article;
      default:
        return Icons.help_outline; // Icon mặc định
    }
  }
}
