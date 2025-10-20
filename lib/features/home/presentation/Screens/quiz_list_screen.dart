import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/quiz_card.dart';
import 'quiz_details_screen.dart';

class QuizListScreen extends StatelessWidget {
  final String subject;
  final List<Map<String, String>> quizzes;
  final String score;
  const QuizListScreen({
    super.key,
    required this.subject,
    required this.quizzes,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(subject, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              quizzes.map((quiz) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => QuizDetailsScreen(
                              subject: subject,
                              quizData: quiz,
                            ),
                      ),
                    );
                  },
                  child: QuizCard(
                    title: subject,
                    subtitle: "Completed on ${quiz["date"]}",
                    score: score,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
