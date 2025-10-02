// features/home/presentation/Screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/tabler.dart';
// import 'package:iconify_flutter/icons/arcticons.dart';

class ProfileScreen extends StatelessWidget {
  final String userName = "Yasmen Magdy";
  final String userEmail = "yamenmagdy322@gmail.com";
  final String profileImageUrl = "assets/image 1.png";
  final int quizzesTaken = 9;
  final int subjects = 3;
  final int averageScore = 88;

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000920),
        elevation: 0,
        title: const Text("Quiz History", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage(profileImageUrl),
            ),
            const SizedBox(height: 12),
            Text(userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(userEmail,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            Column(
              children: [
                StatCard(
                  icon: IconParkOutline.list,
                  label: "All Quizzes taken",
                  value: "$quizzesTaken",
                ),
                const SizedBox(height: 16),
                StatCard(
                  icon: Tabler.books,
                  label: "Subjects",
                  value: "$subjects",
                ),
                const SizedBox(height: 16),
                StatCard(
                  icon: Tabler.star, // Use a Tabler icon string
                  label: "Average Score",
                  value: "$averageScore%",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const StatCard({required this.icon, required this.label, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF000920),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5AC7C7)),
      ),
      child: Row(
        children: [
          Iconify(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}