import 'package:flutter/material.dart';
import '../widgets/quiz_back_button.dart';
import '../widgets/quiz_info_card.dart';
import '../widgets/quiz_instructions_card.dart';
import '../widgets/quiz_journey_start_button.dart';
import '../widgets/quiz_title_bar.dart';
import '../../../home/presentation/widgets/app_constants.dart';

class QuizDetailsScreen extends StatelessWidget {
  const QuizDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const QuizTitleBar(title: 'Math Basics Quiz'),
              SizedBox(height: sy(context, 20)),

              // Top info cards (2 up)
              Row(
                children: [
                  Expanded(
                    child: QuizInfoCard(
                      icon: Icons.list_alt_rounded,
                      title: 'Questions',
                      value: '25',
                      isIconTop: true,
                    ),
                  ),
                  SizedBox(width: sx(context, 12)),
                  Expanded(
                    child: QuizInfoCard(
                      icon: Icons.schedule_rounded,
                      title: 'Time limit',
                      value: '30 Mins',
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
                value: 'Mr.Mohamed Ali',
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
                  // Start quiz action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Quiz Started! Good luck!'),
                      backgroundColor: AppColors.teal,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // Add your quiz start logic here
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
        ),
      ),
    );
  }
}
