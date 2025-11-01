import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatefulWidget {
  final String? teacherName;
  
  const TeacherProfileScreen({super.key, this.teacherName});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  User? user;
  int totalQuizzes = 0;
  int totalSubjects = 0;
  double avgQuestions = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loadTeacherData(user!.uid);
    }
  }

  Future<void> _loadTeacherData(String teacherId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final quizzesSnapshot = await firestore
          .collection(AppConstants.teacherCollection)
          .doc(teacherId)
          .collection(AppConstants.quizzesCollection)
          .get();

      final quizzes = quizzesSnapshot.docs;

      // حساب عدد الكويزات
      totalQuizzes = quizzes.length;

      // حساب عدد المواد الفريدة
      final subjects = quizzes
          .map((doc) => doc.data()[AppConstants.subject])
          .where((s) => s != null)
          .toSet();
      totalSubjects = subjects.length;

      // حساب متوسط عدد الأسئلة
      double totalQuestions = 0;
      for (var doc in quizzes) {
        final questionsSnapshot = await firestore
            .collection(AppConstants.teacherCollection)
            .doc(teacherId)
            .collection(AppConstants.quizzesCollection)
            .doc(doc.id)
            .collection(AppConstants.questionsCollection)
            .get();
        totalQuestions += questionsSnapshot.size;
      }

      avgQuestions =
          totalQuizzes == 0 ? 0 : totalQuestions / totalQuizzes;

      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const designWidth = 390.0;
    const designHeight = 844.0;
    final widthRatio = screenWidth / designWidth;
    final heightRatio = screenHeight / designHeight;

    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      appBar: const CustomAppBar(Title: 'Teacher Profile'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    widget.teacherName ?? user?.displayName ?? "Teacher",
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36 * widthRatio),
                    child: Column(
                      children: [
                        _buildStatCard(
                          icon: Icons.list_alt,
                          label: "All Quizzes Created",
                          value: totalQuizzes.toString(),
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
                        SizedBox(height: 20 * heightRatio),
                        _buildStatCard(
                          icon: Icons.help_outline,
                          label: "Avg. Questions per Quiz",
                          value: avgQuestions.toStringAsFixed(1),
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          Icon(icon, color: Colors.white, size: 28 * widthRatio),
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