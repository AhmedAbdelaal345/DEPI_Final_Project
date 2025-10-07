import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/features/questions/presentation/screens/quiz_page.dart';
import 'package:flutter/material.dart';
import '../widgets/quiz_back_button.dart';
import '../widgets/quiz_info_card.dart';
import '../widgets/quiz_instructions_card.dart';
import '../widgets/quiz_journey_start_button.dart';
import '../widgets/quiz_title_bar.dart';
import '../../../home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class BeforeQuizScreen extends StatelessWidget {
  BeforeQuizScreen({super.key, this.quizId});
  final String? quizId;

  static final String id = "/details";

  Future<DocumentSnapshot<Map<String, dynamic>>> _getQuizData() {
    return FirebaseFirestore.instance.collection("Quizzes").doc(quizId).get();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              return Center(
                child: Text(
                  l10n.quizNotFound,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final quizData = snapshot.data!.data()!;
            final title = quizData["title"] ?? "Quiz";
            final questions = quizData["question_count"]?.toString() ?? "N/A";
            final timeLimit = quizData["duration"]?.toString() ?? "N/A";
            final creator = quizData["teacherId"] ?? "Unknown";

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
                          title: l10n.questions,
                          value: questions,
                          isIconTop: true,
                        ),
                      ),
                      SizedBox(width: sx(context, 12)),
                      Expanded(
                        child: QuizInfoCard(
                          icon: Icons.schedule_rounded,
                          title: l10n.timeLimit,
                          value: l10n.minutesUnit(timeLimit),
                          isIconTop: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sy(context, 12)),

                  // Creator full-width card
                  QuizInfoCard(
                    icon: Icons.person_rounded,
                    title: l10n.creator,
                    value: creator,
                    isIconTop: false,
                  ),
                  SizedBox(height: sy(context, 14)),

                  // Instructions block
                   QuizInstructionsCard(
                     title: l10n.instructions,
                    instructions: [
                      l10n.instruction1,
                      l10n.instruction2,
                      l10n.instruction3,
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
