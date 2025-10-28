import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_cubit.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_state.dart';
import 'package:depi_final_project/features/review_answers/presentation/screens/review_details_screen.dart';
import 'package:depi_final_project/features/review_answers/presentation/widgets/custom_review_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class StudentReviewSelectionScreen extends StatefulWidget {
  final String quizId;
  final String studentId;
  final String quizTitle;

  const StudentReviewSelectionScreen({
    super.key,
    required this.quizId,
    required this.studentId,
    required this.quizTitle,
  });

  @override
  State<StudentReviewSelectionScreen> createState() => _StudentReviewSelectionScreenState();
}

class _StudentReviewSelectionScreenState extends State<StudentReviewSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load the student's answers when screen opens
    context.read<ReviewAnswersCubit>().loadStudentAnswers(
      quizId: widget.quizId,
      studentId: widget.studentId,
    );
  }

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
        title: const Text(
          'Review Your Answers',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ReviewAnswersCubit, ReviewAnswersState>(
        listener: (context, state) {
          if (state is ReviewAnswersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewAnswersLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF4FB3B7),
              ),
            );
          }

          final cubit = context.read<ReviewAnswersCubit>();
          final hasWrongAnswers = cubit.wrongCount > 0;
          final hasCorrectAnswers = cubit.correctCount > 0;
          final hasAnswers = cubit.totalCount > 0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Text(
                  widget.quizTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.judson(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.004),
                Text(
                  'Review your performance',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.judson(
                    fontSize: screenWidth * 0.052,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Score Summary Card
                if (hasAnswers)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreItem(
                          icon: Icons.check_circle,
                          label: 'Correct',
                          value: cubit.correctCount.toString(),
                          color: Colors.green,
                        ),
                        _buildScoreItem(
                          icon: Icons.cancel,
                          label: 'Wrong',
                          value: cubit.wrongCount.toString(),
                          color: Colors.red,
                        ),
                        _buildScoreItem(
                          icon: Icons.quiz,
                          label: 'Total',
                          value: cubit.totalCount.toString(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: screenHeight * 0.05),

                Image.asset(
                  'assets/images/review_answer.png',
                  height: screenHeight * 0.2,
                ),

                SizedBox(height: screenHeight * 0.05),

                // Wrong Answers Button
                CustomReviewButton(
                  text: hasWrongAnswers
                      ? 'Review Wrong Answers (${cubit.wrongCount})'
                      : 'Wrong Answers (0)',
                  onPressed: hasWrongAnswers
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReviewDetailsScreen(
                                fetchWrongAnswers: true,
                              ),
                            ),
                          );
                        }
                      : null,
                  isEnabled: hasWrongAnswers,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Correct Answers Button
                CustomReviewButton(
                  text: hasCorrectAnswers
                      ? 'Review Correct Answers (${cubit.correctCount})'
                      : 'Correct Answers (0)',
                  onPressed: hasCorrectAnswers
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReviewDetailsScreen(
                                fetchWrongAnswers: false,
                              ),
                            ),
                          );
                        }
                      : null,
                  isEnabled: hasCorrectAnswers,
                ),

                SizedBox(height: screenHeight * 0.03),

                // All Answers Button
                CustomReviewButton(
                  text: hasAnswers
                      ? 'Review All Answers (${cubit.totalCount})'
                      : 'All Answers (0)',
                  onPressed: hasAnswers
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReviewDetailsScreen(
                                fetchWrongAnswers: false,
                                showAll: true,
                              ),
                            ),
                          );
                        }
                      : null,
                  isEnabled: hasAnswers,
                ),

                // No data message
                if (!hasAnswers) ...[
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
                          'No answers available',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Complete the quiz to review your answers',
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
                SizedBox(height: screenHeight * 0.03),
                CustomReviewButton(
                  text: 'Chat with Tutor',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
