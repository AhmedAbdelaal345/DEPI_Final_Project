import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/features/questions/presentation/screens/quiz_page.dart';
import 'package:flutter/material.dart';
import '../widgets/quiz_back_button.dart';
import '../widgets/quiz_info_card.dart';
import '../widgets/quiz_instructions_card.dart';
import '../widgets/quiz_journey_start_button.dart';
import '../widgets/quiz_title_bar.dart';
import '../../../home/presentation/widgets/app_constants.dart';

class BeforeQuizScreen extends StatelessWidget {
  BeforeQuizScreen({super.key, this.quizId});
  final String? quizId;

  static final String id = "/details";

  Future<DocumentSnapshot<Map<String, dynamic>>> _getQuizData() {
    return FirebaseFirestore.instance.collection("quizzes").doc(quizId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _getQuizData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  "Quiz not found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final quizData = snapshot.data!.data()!;
            final title = quizData["title"] ?? "Quiz";
            final questions = quizData["questions_count"]?.toString() ?? "N/A";
            final timeLimit = quizData["time_limit"]?.toString() ?? "N/A";
            final creator = quizData["creator_name"] ?? "Unknown";

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizTitleBar(title: title),
                  SizedBox(height: sy(context, 20)),

                  // Top info cards (2 up)
                  Row(
                    children: [
                      Expanded(
                        child: QuizInfoCard(
                          icon: Icons.list_alt_rounded,
                          title: 'Questions',
                          value: questions,
                          isIconTop: true,
                        ),
                      ),
                      SizedBox(width: sx(context, 12)),
                      Expanded(
                        child: QuizInfoCard(
                          icon: Icons.schedule_rounded,
                          title: 'Time limit',
                          value: "$timeLimit Mins",
                          isIconTop: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sy(context, 12)),

                  // Creator full-width card
                  QuizInfoCard(
                    icon: Icons.person_rounded,
                    title: 'Creator',
                    value: creator,
                    isIconTop: false,
                  ),
                  SizedBox(height: sy(context, 14)),

                  // Instructions block
                  const QuizInstructionsCard(
                    instructions: [
                      'Ensure you have a stable internet connection.',
                      'The quiz will automatically submit when the time runs out.',
                      'You cannot pause the quiz once started.',
                    ],
                  ),
                  SizedBox(height: sy(context, 24)),

                  // Beautiful Journey Start Button
                  QuizJourneyStartButton(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        QuizPage.id,
                        arguments:
                            quizId, // 👈 كده نمرر الـ quizId لصفحة الكويز
                      );
                    },
                  ),
                  SizedBox(height: sy(context, 16)),

                  // Back button
                  QuizBackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: sy(context, 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
