import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_app.dart';
import '../widgets/app_constants.dart';
import '../widgets/profile_header.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    final uid = user.uid;
    final firestore = FirebaseFirestore.instance;

    DocumentSnapshot userDoc;
    bool isTeacher = false;

    // Check if the user is a teacher
    userDoc = await firestore.collection('teacher').doc(uid).get();
    if (userDoc.exists) {
      isTeacher = true;
    } else {
      // If not a teacher, assume student
      userDoc = await firestore.collection('Student').doc(uid).get();
      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore.");
      }
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    Map<String, dynamic> stats = {};

    if (isTeacher) {
      // Fetch stats for the teacher
      final quizzesQuery =
          await firestore
              .collection('Quizzes')
              .where('uid', isEqualTo: uid)
              .get();

      final totalQuizzes = quizzesQuery.docs.length;
      final String subjectName = userData['subject'] ?? 'Undefined';

      stats = {'totalQuizzes': totalQuizzes, 'subjectName': subjectName};
    } else {
      // Fetch stats for the student
      final studentQuizResults =
          await firestore
              .collection('Student')
              .doc(uid)
              .collection('questions')
              .get();

      final totalQuizzes = studentQuizResults.docs.length;
      if (totalQuizzes > 0) {
        double totalScore = 0;
        Set<String> subjects = {};

        // Fetch subject for each quiz result
        for (var resultDoc in studentQuizResults.docs) {
          final quizId = resultDoc.id;
          final quizDoc =
              await firestore.collection('Quizzes').doc(quizId).get();

          if (quizDoc.exists && quizDoc.data()!.containsKey('subject')) {
            subjects.add(quizDoc['subject']);
          }

          final resultData = resultDoc.data();
          totalScore += (resultData['score'] as num? ?? 0.0);
        }

        final averageScore = (totalScore / totalQuizzes * 100).round();

        stats = {
          'totalQuizzes': totalQuizzes,
          'totalSubjects': subjects.length,
          'averageScore': '$averageScore%',
        };
      } else {
        stats = {'totalQuizzes': 0, 'totalSubjects': 0, 'averageScore': '0%'};
      }
    }

    return {
      'isTeacher': isTeacher,
      'fullName': userData['fullName'] ?? 'No Name',
      'email': userData['email'] ?? 'No Email',
      ...stats,
    };
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
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF000920),
        elevation: 0,
        title: Text(
          l10n.profile,
          style: GoogleFonts.irishGrover(
            fontSize: sx(context, 32),
            fontWeight: FontWeight.w400,
            color: ColorApp.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No profile data found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!;
          final bool isTeacher = data['isTeacher'] ?? false;

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  fullName: data['fullName'],
                  email: data['email'],
                  widthRatio: widthRatio,
                  heightRatio: heightRatio,
                ),
                SizedBox(height: 32 * heightRatio),
                Padding(
                  padding: EdgeInsets.only(
                    left: 37 * widthRatio,
                    right: 36 * widthRatio,
                  ),
                  child: Column(
                    children: [
                      StatCard(
                        icon: Icons.list,
                        label:
                            isTeacher
                                ? "Quizzes Created"
                                : l10n.allQuizzesTaken,
                        value: data['totalQuizzes'].toString(),
                        widthRatio: widthRatio,
                        heightRatio: heightRatio,
                      ),
                      SizedBox(height: 20 * heightRatio),
                      StatCard(
                        icon: Icons.book,
                        label: isTeacher ? "Subject" : l10n.subjects,
                        value:
                            isTeacher
                                ? data['subjectName'].toString()
                                : data['totalSubjects'].toString(),
                        widthRatio: widthRatio,
                        heightRatio: heightRatio,
                      ),
                      if (!isTeacher) ...[
                        SizedBox(height: 16 * heightRatio),
                        StatCard(
                          icon: Icons.star_border,
                          label: l10n.averageScore,
                          value: data['averageScore'].toString(),
                          widthRatio: widthRatio,
                          heightRatio: heightRatio,
                          isLast: true,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 20 * heightRatio),
              ],
            ),
          );
        },
      ),
    );
  }
}
