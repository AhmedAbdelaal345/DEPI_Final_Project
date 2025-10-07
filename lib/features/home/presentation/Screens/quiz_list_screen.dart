import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/quiz_card.dart';
import '../widgets/custom_app_bar.dart';
import 'quiz_details_screen.dart';

class QuizListScreen extends StatelessWidget {
  final String subject;
  final List<Map<String, String>> quizzes;

  const QuizListScreen({
    super.key,
    required this.subject,
    required this.quizzes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      endDrawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: subject,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            return GestureDetector(
              onTap: () => _navigateToQuizDetails(context, quiz),
              child: QuizCard(
                title: quiz["title"]!,
                subtitle: "Completed on ${quiz["date"]}",
                score: quiz["score"]!,
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToQuizDetails(BuildContext context, Map<String, String> quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizDetailsScreen(
          subject: subject,
          quizData: quiz,
        ),
      ),
    );
  }
}
