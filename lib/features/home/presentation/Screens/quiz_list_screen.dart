import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/profile_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/quiz_details_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/quiz_card.dart';
import 'package:depi_final_project/features/review_answers/presentation/widgets/app_drawer_1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizListScreen extends StatelessWidget {
  final String subject;
  final List<Map<String, String>> quizzes;
  final String
  score; // This is the average score, not needed for individual cards

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
      endDrawer: AppDrawer(
        onItemTapped:  (index) {
          Navigator.pop(context);
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperPage(initialIndex: 0),
              ),
                  (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperPage(initialIndex: 1),
              ),
                  (Route<dynamic> route) => false,
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperPage(initialIndex: 3),
              ),
                  (Route<dynamic> route) => false,
            );
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            subject,
            style: GoogleFonts.irishGrover(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
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
