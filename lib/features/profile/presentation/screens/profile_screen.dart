// features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import '../widgets/profile_header.dart';
import '../widgets/pro_upgrade_card.dart';
import '../widgets/stat_card.dart';
import 'pro_features_screen.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;
  final int quizzesTaken;
  final int subjects;
  final int averageScore;
  final bool isPro;

  const ProfileScreen({
    super.key,
    this.userName = "Yasmen Magdy",
    this.userEmail = "yamenmagdy322@gmail.com",
    this.profileImageUrl = "assets/images/cat.png",
    this.quizzesTaken = 9,
    this.subjects = 3,
    this.averageScore = 88,
    this.isPro = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      appBar: const CustomAppBar(
        title: "Profile",
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header with Animation
            ProfileHeader(
              userName: userName,
              userEmail: userEmail,
              profileImageUrl: profileImageUrl,
              isPro: isPro,
            ),
            const SizedBox(height: 24),

            // Pro Upgrade Card (only if not pro)
            if (!isPro) ...[
              ProUpgradeCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProFeaturesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],


            // Statistics Cards
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
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
          icon: Tabler.star,
          label: "Average Score",
          value: "$averageScore%",
        ),
      ],
    );
  }
}
