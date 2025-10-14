import 'package:depi_final_project/features/home/presentation/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/presentation/manager/history_cubit/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<HistoryCubit>().getQuizzesForStudent(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
   
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    
    const designWidth = 390.0;
    const designHeight = 844.0;
    
   
    final widthRatio = screenWidth / designWidth;
    final heightRatio = screenHeight / designHeight;

    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000920),
        elevation: 0,
        title: Text(l10n.profile, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmptyState) {
            return  SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60 * heightRatio),
                  CircleAvatar(
                    radius: 60 * widthRatio,
                    backgroundImage: const AssetImage(
                      'assets/profile_image.jpg',
                    ),
                    onBackgroundImageError: (_, __) {},
                  ),
                  SizedBox(height: 10 * heightRatio),
                  Text(
                    user?.displayName ?? "User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 * widthRatio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? "",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14 * widthRatio,
                    ),
                  ),
                  SizedBox(height: 32 * heightRatio),

                  // Cards
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36 * widthRatio),
                    child: Column(
                      children: [
                        _buildStatCard(
                          icon: Icons.list,
                          label: "All Quizzes Taken",
                          value: "0", // ✅ من Firestore
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                        ),
                        SizedBox(height: 20 * heightRatio),
                        _buildStatCard(
                          icon: Icons.book,
                          label: "Subjects",
                          value: "0",
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                        ),
                        SizedBox(height: 16 * heightRatio),
                        _buildStatCard(
                          icon: Icons.star_border,
                          label: "Average Score",
                          value: "0%",
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

          } else if (state is ErrorState) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (state is LoadedState) {
            final subjects = state.groupedQuizzes;
            final totalSubjects = subjects.keys.length;
            final totalQuizzes = state.totalQuizzes; // ✅ العدد الحقيقي من Firestore

            // حساب متوسط النتيجة (اختياري)
            List<int> allScores = [];
            for (var list in subjects.values) {
              for (var quiz in list) {
                if (quiz.score != null && quiz.total != null) {
                  allScores.add(
                      ((quiz.score / quiz.total) * 100).round());
                }
              }
            }
            int averageScore = allScores.isEmpty
                ? 0
                : (allScores.reduce((a, b) => a + b) / allScores.length).round();

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60 * heightRatio),
                  CircleAvatar(
                    radius: 60 * widthRatio,
                    backgroundImage: const AssetImage(
                      'assets/profile_image.jpg',
                    ),
                    onBackgroundImageError: (_, __) {},
                  ),
                  SizedBox(height: 10 * heightRatio),
                  Text(
                    user?.displayName ?? "User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 * widthRatio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? "",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14 * widthRatio,
                    ),
                  ),
                  SizedBox(height: 32 * heightRatio),

                  // Cards
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36 * widthRatio),
                    child: Column(
                      children: [
                        _buildStatCard(
                          icon: Icons.list,
                          label: "All Quizzes Taken",
                          value: totalQuizzes.toString(), // ✅ من Firestore
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                        ),
                        SizedBox(height: 20 * heightRatio),
                        _buildStatCard(
                          icon: Icons.book,
                          label: "Subjects",
                          value: totalSubjects.toString(),
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                        ),
                        SizedBox(height: 16 * heightRatio),
                        _buildStatCard(
                          icon: Icons.star_border,
                          label: "Average Score",
                          value: "$averageScore%",
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  } 
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required double widthRatio,
    required double heightRatio,
    bool isLast = false,
  }) {
    return Container(
      width: 317 * widthRatio,
      height: isLast ? 89 * heightRatio : 82 * heightRatio,
      padding: EdgeInsets.symmetric(
        horizontal: 20 * widthRatio,
        vertical: 16 * heightRatio,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF000B27),
        border: Border.all(
          color: const Color(0xFF5AC7C7),
          width: 1 * widthRatio,
        ),
        borderRadius: BorderRadius.circular(10 * widthRatio),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28 * widthRatio,
          ),
          SizedBox(width: 16 * widthRatio),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * widthRatio,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24 * widthRatio,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
