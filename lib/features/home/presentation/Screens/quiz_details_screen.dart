// myproject/lib/screens/quiz_details_screen.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import '../widgets/app_drawer.dart';
import '../widgets/detail_item.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_app_bar.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String subject;
  final Map<String, String> quizData;

  const QuizDetailsScreen({
    super.key,
    required this.subject,
    required this.quizData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      endDrawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: "${quizData["title"]} Quiz",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildQuizDetails(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Column(
      children: [
        const DetailItem(
          icon: IconParkOutline.list,
          label: "Questions",
          value: "25",
        ),
        const SizedBox(height: 16),
        const DetailItem(
          icon: Lucide.alarm_clock,
          label: "Time limit",
          value: "30 Mins",
        ),
        const SizedBox(height: 16),
        const DetailItem(
          icon: Mdi.account_tie_outline,
          label: "Creator",
          value: "Mr. Mohamed Ali",
        ),
        const SizedBox(height: 16),
        DetailItem(
          icon: Mdi.calendar_month,
          label: "Completed on",
          value: quizData["date"]!,
        ),
        const SizedBox(height: 16),
        DetailItem(
          icon: Mdi.star_circle_outline,
          label: "Score",
          value: quizData["score"]!,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
          label: "Resolve Quiz",
          onPressed: () {
            // TODO: Implement resolve quiz functionality
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          label: "View Answers",
          onPressed: () {
            // TODO: Implement view answers functionality
          },
        ),
      ],
    );
  }
}
