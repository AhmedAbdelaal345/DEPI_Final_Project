// myproject/lib/screens/quiz_details_screen.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import '../widgets/app_drawer.dart';
import '../widgets/detail_item.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String subject;
  final Map<String, String> quizData;

  const QuizDetailsScreen(
      {super.key, required this.subject, required this.quizData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1C2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${quizData["title"]} Quiz",
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FB3B7),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                  },
                  child: const Text("Resolve Quiz",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FB3B7),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                  },
                  child: const Text("View Answers",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
