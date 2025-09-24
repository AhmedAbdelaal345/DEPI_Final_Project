import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/quiz_card.dart';
import 'quiz_list_screen.dart';

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({super.key});

  final Map<String, List<Map<String, String>>> subjects = const {
    "Math": [
      {"title": "Math Basics", "date": "23/9/2025", "score": "80%"},
      {"title": "Math1", "date": "12/9/2025", "score": "76%"},
      {"title": "Math2", "date": "10/9/2025", "score": "83%"},
    ],
    "Physics": [
      {"title": "Physics Basics", "date": "20/9/2025", "score": "78%"},
      {"title": "Physics1", "date": "15/9/2025", "score": "72%"},
    ],
    "Programming 1": [
      {"title": "Intro to C++", "date": "18/9/2025", "score": "88%"},
      {"title": "Data Structures", "date": "14/9/2025", "score": "90%"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1C2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {},
        ),
        title:
            const Text("Quiz History", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: subjects.entries.map((entry) {
            String subjectName = entry.key;
            List<Map<String, String>> quizzes = entry.value;

            double avg = quizzes
                    .map((q) => int.parse(q["score"]!.replaceAll("%", "")))
                    .reduce((a, b) => a + b) /
                quizzes.length;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizListScreen(
                      subject: subjectName,
                      quizzes: quizzes,
                    ),
                  ),
                );
              },
              child: QuizCard(
                title: subjectName,
                subtitle: "${quizzes.length} quizzes",
                score: "${avg.toStringAsFixed(0)}%",
                showAverage: true,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
