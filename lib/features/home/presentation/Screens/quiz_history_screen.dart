import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_state.dart';
import 'package:depi_final_project/features/home/model/history_model.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/quiz_card.dart'; // لو لازلت تستخدمه في مكان آخر
import 'quiz_list_screen.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(Title: l10n.quizHistory),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.teal),
            );
          }

          if (state is EmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.quiz_outlined,
                    color: Colors.white54,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No quiz history yet',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start taking quizzes to see your progress',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
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
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.error,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: "Retry",
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

            // If no groups, show empty
            if (groupQuizzes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 64, color: Colors.white24),
                    const SizedBox(height: 12),
                    const Text('No quiz history yet', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              );
            }

            // Build a clean list of subject cards
            final items = groupQuizzes.entries.toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = items[index];
                  final String subjectName = entry.key;
                  final List<QuizHistoryModel> quizzes = entry.value;

                  final double avg =
                      quizzes.isEmpty ? 0.0 : quizzes.map((q) => q.accuracy).reduce((a, b) => a + b) / quizzes.length;

                  // prepare quizzesForList as before
                  final List<Map<String, String>> quizzesForList = quizzes.map((q) {
                    return {
                      AppConstants.title: subjectName,
                      AppConstants.id: q.quizId,
                      "date": q.formattedDate,
                      AppConstants.score: q.accuracyPercentage,
                    };
                  }).toList();

                  // Visual percentage string
                  final String avgPercent = "${(avg * 100).toStringAsFixed(0)}%";

                  return Card(
                    color: const Color(0xFF0F1220),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            // Circular progress with percentage
                            _AverageCircle(percent: avg),

                            const SizedBox(width: 12),

                            // Subject & meta
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subjectName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${quizzes.length} quizzes",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // small progress bar for avg
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      minHeight: 6,
                                      value: avg.clamp(0.0, 1.0),
                                      backgroundColor: Colors.white12,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Chevron
                            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6))
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

/// Small widget that draws a circular percent indicator (without extra packages)
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
          // background circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
            ),
          ),
          // foreground arc using LinearProgressIndicator rotated
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
            ),
          ),
          // percent text
          Text(
            display,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
