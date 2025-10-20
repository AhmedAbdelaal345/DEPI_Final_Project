import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/Screens/quiz_details_screen.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_drawer.dart';
import 'package:depi_final_project/features/home/presentation/widgets/quiz_card.dart';
import 'package:flutter/material.dart';

class QuizListScreen extends StatelessWidget {
  final String subject;
  final List<Map<String, String>> quizzes;
  final String score; // This is the average score, not needed for individual cards

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
          children: quizzes.map((quiz) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizDetailsScreen(
                      subject: subject,
                      quizData: quiz,
                    ),
                  ),
                );
              },
              child: QuizCard(
                title: quiz[AppConstants.title] ?? quiz["title"] ?? "Quiz",
                id: quiz[AppConstants.id] ?? quiz["id"] ?? "0",
                subtitle: "Completed on ${quiz["date"]}",
                score: quiz[AppConstants.score] ?? quiz["score"] ?? "0%", 
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}