import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizz/screen/question_screen.dart';
import 'package:quizz/widgets/questions_summary.dart';
import 'package:quizz/model/question.dart';
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.chosenAnswers,  required this.question, required this.categoryId, required this.categoryName});

  final List<String> chosenAnswers;
  final List<Result> question;
  final int categoryId;
  final String categoryName;

  List<Map<String,Object>> get summaryData{
    final List<Map<String,Object>> summary = []; // Mã hóa chuỗi
    final HtmlUnescape htmlUnescape = HtmlUnescape();

    for(var i = 0; i < chosenAnswers.length;i++){
      summary.add({
        'question_index': i,
        'question': htmlUnescape.convert(question[i].question),
        'correct_answer':htmlUnescape.convert(question[i].correctAnswer),
        'user_answer': htmlUnescape.convert(chosenAnswers[i])
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = question.length;
    final numCorrectQuestions = summaryData.where(
            (data) => data['user_answer']  == data['correct_answer']
    ).length;
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You answered $numCorrectQuestions out of $numTotalQuestions question correctly!',
                style: TextStyle(
                  color: const Color.fromARGB(255, 230, 200, 253),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              QuestionsSummary(summaryData),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => QuestionScreen(
                        categoryId: categoryId,
                        categoryName: categoryName,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Restart Quiz!'),
              )
            ],
          ),
        ));
  }
}
