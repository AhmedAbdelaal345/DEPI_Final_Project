import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_state.dart';
import 'package:depi_final_project/features/home/model/history_model.dart';
import 'package:depi_final_project/features/home/presentation/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'quiz_list_screen.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<HistoryCubit>().getQuizzesForStudent(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(Title: l10n.quizHistory),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryTeal),
            );
          }

          if (state is EmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    color: AppColors.white54,
                    size: 80,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.noQuizHistoryYet, // TODO: Add to .arb
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSizes.lg,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.startTakingQuizzesToSeeProgress, // TODO: Add to .arb
                    style: TextStyle(color: AppColors.white54),
                  ),
                ],
              ),
            );
          }

          if (state is ErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 60,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      state.error,
                      style: TextStyle(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: l10n.retry,
                    onTap: () {
                      final userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        context.read<HistoryCubit>().getQuizzesForStudent(
                          userId,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }

          if (state is LoadedState) {
            final groupQuizzes = state.groupedQuizzes;

            if (groupQuizzes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: AppColors.white.withOpacity(0.24),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.noQuizHistoryYet,
                      style: TextStyle(color: AppColors.white54),
                    ),
                  ],
                ),
              );
            }

            final items = groupQuizzes.entries.toList();

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final entry = items[index];
                  final String subjectName = entry.key;
                  final List<QuizHistoryModel> quizzes = entry.value;

                  final double avg = quizzes.isEmpty
                      ? 0.0
                      : quizzes.map((q) => q.accuracy).reduce((a, b) => a + b) /
                          quizzes.length;

                  final List<Map<String, String>> quizzesForList =
                      quizzes.map((q) {
                    return {
                      AppConstants.title: subjectName,
                      AppConstants.id: q.quizId,
                      "date": q.formattedDate,
                      AppConstants.score: q.accuracyPercentage,
                    };
                  }).toList();

                  final String avgPercent =
                      "${(avg * 100).toStringAsFixed(0)}%";

                  return Card(
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.mediumBorderRadius,
                    ),
                    elevation: 2,
                    child: InkWell(
                      borderRadius: AppBorderRadius.mediumBorderRadius,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizListScreen(
                              subject: subjectName,
                              quizzes: quizzesForList,
                              score: avgPercent,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            _AverageCircle(percent: avg),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subjectName,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: AppFontSizes.md,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    l10n.quizzesCount(quizzes.length), // TODO: Add to .arb
                                    style: TextStyle(
                                      color: AppColors.white54,
                                      fontSize: AppFontSizes.sm,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      minHeight: 6,
                                      value: avg.clamp(0.0, 1.0),
                                      backgroundColor: AppColors.white.withOpacity(0.12),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryTeal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.white54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

/// Small widget that draws a circular percent indicator
class _AverageCircle extends StatelessWidget {
  final double percent; // 0..1

  const _AverageCircle({required this.percent});

  @override
  Widget build(BuildContext context) {
    final display = "${(percent * 100).toStringAsFixed(0)}%";
    
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.12),
            ),
          ),
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryTeal,
              ),
            ),
          ),
          Text(
            display,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppFontSizes.xs,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
