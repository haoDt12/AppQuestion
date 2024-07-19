import 'package:flutter/material.dart';
import 'package:quizz/model/question.dart';
import 'package:quizz/screen/results_screen.dart';
import 'package:quizz/widgets/answer_button.dart';
import 'package:quizz/services/question_api.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.onSelectAnswer,
  });

  final int categoryId;
  final String categoryName;
  final void Function(String answer)? onSelectAnswer;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late Future<Question> futureQuestion;
  var currentQuestionIndex = 0;
  late List<String> chosenAnswers = [];
  late Question questions; // Biến để lưu danh sách câu hỏi

  void answerQuestion(String selectedAnswer) {
    if (widget.onSelectAnswer != null) {
      widget.onSelectAnswer!(selectedAnswer);
    }
    setState(() {
      chosenAnswers.add(selectedAnswer);
      currentQuestionIndex++;
      if (currentQuestionIndex >= questions.results.length) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return ResultsScreen(
                  chosenAnswers: chosenAnswers,
                  question: questions.results, // Truyền danh sách câu hỏi
                  categoryId: widget.categoryId,
                  categoryName: widget.categoryName);
            },
          ),
        );
      }
    });
  }
  @override
  void initState() {
    super.initState();
    futureQuestion = QuestionApi.fetchQuestions(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    var questionNumber = currentQuestionIndex + 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.blue,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      body: FutureBuilder<Question>(
        future: futureQuestion,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.black,
                  size: 50,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var unescape = HtmlUnescape();
            questions = snapshot.data!; // Lưu dữ liệu câu hỏi
            if (currentQuestionIndex >= questions.results.length) {
              return Container(); // Không hiển thị gì khi hết câu hỏi, đã xử lý trong answerQuestion
            }
            final result = questions.results[currentQuestionIndex];
            final question = unescape.convert(result.question);
            List<String> answers = [
              ...result.incorrectAnswers,
              result.correctAnswer
            ];
            answers =
                answers.map((answer) => unescape.convert(answer)).toList();
            answers.shuffle();

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      '$questionNumber/10',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        question,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20),
                      ...answers.map((answer) {
                        return AnswerButton(
                          answerText: answer,
                          onTap: () {
                            answerQuestion(answer);
                          },
                        );
                      })
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
