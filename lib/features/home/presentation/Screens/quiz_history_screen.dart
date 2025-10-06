import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/presentation/manager/history_cubit/history_state.dart';
import 'package:depi_final_project/features/home/presentation/model/history_model.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/quiz_card.dart';
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
    BlocProvider.of<HistoryCubit>(context).getQuizzesForStudent(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Quiz History",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: groupQuizzes.entries.map((entry) {
                  String subjectName = entry.key;
                  List<QuizHistoryModel> quizzes = entry.value;

                  // Calculate average
                  double avg = quizzes.isEmpty
                      ? 0.0
                      : quizzes
                              .map((q) => q.accuracy)
                              .reduce((a, b) => a + b) /
                          quizzes.length;

                  // Convert to format expected by QuizListScreen
                  List<Map<String, String>> quizzesForList =
                      quizzes.map((q) {
                    return {
                      "title": q.quizId,
                      "date": q.formattedDate,
                      "score": q.accuracyPercentage,
                    };
                  }).toList();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizListScreen(
                            subject: subjectName,
                            quizzes: quizzesForList,
                            score:"${(avg * 100).toStringAsFixed(0)}%",
                          ),
                        ),
                      );
                    },
                    child: QuizCard(
                      title: subjectName,
                      subtitle: "${quizzes.length} quizzes",
                      score: "${(avg * 100).toStringAsFixed(0)}%",
                      showAverage: true,
                    ),
                  );
                }).toList(),
              ),
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
}