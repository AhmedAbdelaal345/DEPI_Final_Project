import 'package:depi_final_project/features/auth/presentation/cubit/login_cubit.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/Screens/wrapper_page.dart';
import '../cubit/review_answers_cubit.dart';
import '../widgets/app_drawer_1.dart';
import '../widgets/custom_review_button.dart';
import 'review_details_screen.dart';

class ReviewSelectionScreen extends StatelessWidget {
  const ReviewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      endDrawer: AppDrawer1(
        onItemTapped: (index) async {
          final isTeacher =
              await BlocProvider.of<LoginCubit>(context).isTeacher();

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder:
                  (context) =>
                      WrapperPage(initialIndex: index, isTeacher: isTeacher),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
        child: Column(
          children: [
            Text(
              'Review your Answers',
              textAlign: TextAlign.center,
              style: GoogleFonts.judson(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.004),
            Text(
              'Which Answers you would review first',
              textAlign: TextAlign.center,
              style: GoogleFonts.judson(
                fontSize: screenWidth * 0.052,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Image.asset(
              'assets/images/review_answer.png',
              height: screenHeight * 0.22,
            ),
            SizedBox(height: screenHeight * 0.1),

            // Check if ReviewAnswersCubit is available and has data
            BlocBuilder<ReviewAnswersCubit, ReviewAnswersState>(
              builder: (context, state) {
                final cubit = context.read<ReviewAnswersCubit>();
                final hasWrongAnswers = cubit.wrongCount > 0;
                final hasCorrectAnswers = cubit.correctCount > 0;

                return Column(
                  children: [
                    // Wrong Answers Button
                    CustomReviewButton(
                      text:
                          hasWrongAnswers
                              ? 'Wrong Answers (${cubit.wrongCount})'
                              : 'Wrong Answers (0)',
                      onPressed:
                          hasWrongAnswers
                              ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ReviewDetailsScreen(
                                          fetchWrongAnswers: true,
                                        ),
                                  ),
                                );
                              }
                              : null, // Disable if no wrong answers
                      isEnabled: hasWrongAnswers,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Correct Answers Button
                    CustomReviewButton(
                      text:
                          hasCorrectAnswers
                              ? 'Correct Answers (${cubit.correctCount})'
                              : 'Correct Answers (0)',
                      onPressed:
                          hasCorrectAnswers
                              ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ReviewDetailsScreen(
                                          fetchWrongAnswers: false,
                                        ),
                                  ),
                                );
                              }
                              : null, // Disable if no correct answers
                      isEnabled: hasCorrectAnswers,
                    ),

                    // Show message if no data available
                    if (!hasWrongAnswers && !hasCorrectAnswers) ...[
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No quiz results available',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Complete a quiz first to review your answers',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.orange.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
