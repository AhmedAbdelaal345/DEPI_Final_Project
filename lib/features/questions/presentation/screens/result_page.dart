import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/primary_button.dart';
import 'package:depi_final_project/features/review_answers/presentation/screens/review_details_screen.dart'
    show ReviewDetailsScreen;
import 'package:flutter/material.dart';

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracy;
  final List<Map<String, dynamic>>?
  detailedResults; // Optional: for review answers

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    this.detailedResults,
  });
}

class ResultPage extends StatelessWidget {
  final QuizResult? quizResult;

  const ResultPage({super.key, this.quizResult});

  static const id = "/resultpage";

  @override
  Widget build(BuildContext context) {
    // Calculate accuracy percentage for display
    final accuracyPercentage = (quizResult!.accuracy * 100).toInt();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: sy(context, 40)),
              Text(
                "Quiz Completed!",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: sy(context, 21)),
              Text(
                "Your Performance Summary",
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 24,
                ),
              ),
              SizedBox(height: sy(context, 60)),

              // Circular Progress Indicator with dynamic value
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: quizResult!.accuracy,
                      strokeWidth: 12,
                      backgroundColor: AppColors.bg.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getAccuracyColor(quizResult!.accuracy),
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$accuracyPercentage%",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Score",
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: sy(context, 60)),

              // Statistics Row with dynamic values
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    "$accuracyPercentage%",
                    "Accuracy",
                    AppColors.tealHighlight,
                  ),
                  _buildStatColumn(
                    "${quizResult!.correctAnswers}",
                    "Correct",
                    Colors.green,
                  ),
                  _buildStatColumn(
                    "${quizResult!.wrongAnswers}",
                    "Wrong",
                    Colors.red,
                  ),
                ],
              ),

              SizedBox(height: sy(context, 60)),

              // Performance message
              _buildPerformanceMessage(quizResult!.accuracy),

              Spacer(),

              // Action buttons (removed Expanded to fix layout issues)
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: "Review Answers",
                  onTap: () {
                    Navigator.pushNamed(context, ReviewDetailsScreen.id);
                  },
                ),
              ),
              SizedBox(height: sy(context, 16)),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: "Back to Home",
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      WrapperPage.id,
                      (route) => false,
                    );
                  },
                ),
              ),

              SizedBox(height: sy(context, 23)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceMessage(double accuracy) {
    String message;
    Color messageColor;

    if (accuracy >= 0.9) {
      message = "Excellent work! 🎉";
      messageColor = Colors.green;
    } else if (accuracy >= 0.7) {
      message = "Good job! 👍";
      messageColor = AppColors.tealHighlight;
    } else if (accuracy >= 0.5) {
      message = "Not bad, keep practicing! 📚";
      messageColor = Colors.orange;
    } else {
      message = "Keep studying and try again! 💪";
      messageColor = Colors.red;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: messageColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: messageColor.withOpacity(0.3)),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: messageColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return AppColors.tealHighlight;
    if (accuracy >= 0.4) return Colors.orange;
    return Colors.red;
  }
}
