import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/quiz_card.dart';
import '../widgets/custom_app_bar.dart';
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
      appBar: const CustomAppBar(
        title: "Quiz History",
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: subjects.entries.length,
          itemBuilder: (context, index) {
            final entry = subjects.entries.elementAt(index);
            return _buildSubjectCard(context, entry.key, entry.value);
          },
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    String subjectName,
    List<Map<String, String>> quizzes,
  ) {
    final averageScore = _calculateAverageScore(quizzes);

    return GestureDetector(
      onTap: () => _navigateToQuizList(context, subjectName, quizzes),
      child: QuizCard(
        title: subjectName,
        subtitle: "${quizzes.length} quizzes",
        score: "${averageScore.toStringAsFixed(0)}%",
        showAverage: true,
      ),
    );
  }

  double _calculateAverageScore(List<Map<String, String>> quizzes) {
    final scores = quizzes.map(
      (q) => int.parse(q["score"]!.replaceAll("%", "")),
    );
    return scores.reduce((a, b) => a + b) / quizzes.length;
  }

  void _navigateToQuizList(
    BuildContext context,
    String subjectName,
    List<Map<String, String>> quizzes,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizListScreen(
          subject: subjectName,
          quizzes: quizzes,
        ),
      ),
    );
  }
}
