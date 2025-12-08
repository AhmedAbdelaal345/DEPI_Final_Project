import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/Screens/quiz_details_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/widgets/quiz_card.dart';
import 'package:depi_final_project/features/review_answers/presentation/widgets/app_drawer_1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final bool isEmpty = quizzes.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      endDrawer: AppDrawer(
        onItemTapped: (index) {
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
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            subject,
            style: GoogleFonts.irishGrover(
              fontSize: AppFontSizes.xxl,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Header with subject and average score
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: AppBorderRadius.mediumBorderRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppFontSizes.md,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${l10n.averageScore} • $score', // TODO: Add to .arb
                          style: TextStyle(
                            color: AppColors.white54,
                            fontSize: AppFontSizes.sm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),

            // Content list or empty state
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt_outlined,
                            size: 64,
                            color: AppColors.white.withOpacity(0.24),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.noQuizzesYetForSubject, // TODO: Add to .arb
                            style: TextStyle(
                              color: AppColors.white54,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: quizzes.length,
                      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        final title = quiz[AppConstants.title] ?? 'Quiz';
                        final id = quiz[AppConstants.id] ?? '0';
                        final date = quiz['date'] ?? '';
                        final qScore = quiz[AppConstants.score] ?? '0%';

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
                            subtitle: "${l10n.completedOn} $date",
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
