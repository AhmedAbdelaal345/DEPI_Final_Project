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
  final String score; // average score string (e.g. "75%")

  const QuizListScreen({
    super.key,
    required this.subject,
    required this.quizzes,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = quizzes.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      endDrawer: AppDrawer(
        onItemTapped: (index) {
          Navigator.pop(context);
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WrapperPage(initialIndex: 0)),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WrapperPage(initialIndex: 1)),
              (Route<dynamic> route) => false,
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WrapperPage(initialIndex: 3)),
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
          children: [
            // Simple header: subject + average text (no icons)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1220),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Average score • $score',
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // kept empty space on purpose — no extra icons
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Content list or empty state
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.list_alt_outlined, size: 64, color: Colors.white24),
                          const SizedBox(height: 12),
                          Text('No quizzes yet for this subject', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: quizzes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        final title = quiz[AppConstants.title] ?? quiz['title'] ?? 'Quiz';
                        final id = quiz[AppConstants.id] ?? quiz['id'] ?? '0';
                        final date = quiz['date'] ?? '';
                        final qScore = quiz[AppConstants.score] ?? quiz['score'] ?? '0%';

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
                            title: title,
                            id: id,
                            subtitle: "Completed on $date",
                            score: qScore,
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
