import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/primary_button.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/result_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/model/question_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../review_answers/presentation/screens/review_selection_screen.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracy;
  final List<Map<String, dynamic>>? detailedResults;
  final String quizId;
  final List<QuestionModel> questions;
  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    required this.quizId,
    required this.questions,
    this.detailedResults,
  });
}

class ResultPage extends StatelessWidget {
  final QuizResult? quizResult;

  const ResultPage({super.key, this.quizResult});

  static const id = "/resultpage";

  @override
  Widget build(BuildContext context) {
    final accuracyPercentage = (quizResult!.accuracy * 100).toInt();
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: sy(context, 40)),
              Text(
                l10n.quizCompleted,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: sy(context, 21)),
              Text(
                l10n.yourPerformanceSummary,
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
                        l10n.score,
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
                    l10n.accuracy,
                    AppColors.tealHighlight,
                  ),
                  _buildStatColumn(
                    "${quizResult!.correctAnswers}",
                    l10n.correct,
                    Colors.green,
                  ),
                  _buildStatColumn(
                    "${quizResult!.wrongAnswers}",
                    l10n.wrong,
                    Colors.red,
                  ),
                ],
              ),

                SizedBox(height: sy(context, 60)),

              // Performance message
              _buildPerformanceMessage(context,quizResult!.accuracy),

                SizedBox(height: sy(context, 60)),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: l10n.reviewAnswers,
                    onTap: () async {
                      
                      await BlocProvider.of<ResultCubit>(
                        context,
                      ).saveStudentQuizResult(
                        
                        studentId: FirebaseAuth.instance.currentUser!.uid,
                        quizId: quizResult!.quizId,
                        questionsWithAnswers: quizResult!.detailedResults!,
                        questions: quizResult!.questions,
                        status:
                            quizResult!.correctAnswers /
                                        quizResult!.totalQuestions >=
                                    0.5
                                ? "Pass"
                                : "Fail",
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewSelectionScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: sy(context, 16)),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: l10n.backToHome,
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

  Widget _buildPerformanceMessage(BuildContext context,double accuracy) {
    final l10n = AppLocalizations.of(context);
    String message;
    Color messageColor;

    if (accuracy >= 0.9) {
      message = l10n.excellentWork;
      messageColor = Colors.green;
    } else if (accuracy >= 0.7) {
      message = l10n.goodJob;
      messageColor = AppColors.tealHighlight;
    } else if (accuracy >= 0.5) {
      message = l10n.notBadKeepPracticing;
      messageColor = Colors.orange;
    } else {
      message = l10n.keepStudying;
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
