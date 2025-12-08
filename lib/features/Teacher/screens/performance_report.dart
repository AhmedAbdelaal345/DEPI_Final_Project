// performance_report_screen.dart
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
import 'package:depi_final_project/features/chat/cubit/chat_cubit.dart';
import 'package:depi_final_project/features/chat/data/repositories/chat_repository.dart';
import 'package:depi_final_project/features/chat/presentation/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceReportScreen extends StatefulWidget {
  final List<String> quizTitles;
  final String uid;

  const PerformanceReportScreen({
    required this.uid,
    required this.quizTitles,
    Key? key,
  }) : super(key: key);

  @override
  State<PerformanceReportScreen> createState() =>
      _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  List<Map<String, dynamic>> quizStudents = [];
  String? selectedQuiz;
  bool isLoading = false;
  double averageScore = 0.0;
  double passRate = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.quizTitles.isNotEmpty) {
      selectedQuiz = widget.quizTitles.last;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadQuizData(selectedQuiz!);
      });
    }
  }

  Future<void> _loadQuizData(String quizTitle) async {
    setState(() {
      isLoading = true;
      quizStudents = [];
      averageScore = 0.0;
      passRate = 0.0;
    });

    try {
      final cubit = context.read<CreateQuizCubit>();
      final quizIds = await cubit.getQuiz(widget.uid, quizTitle);

      if (quizIds.isEmpty) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      final quizId = quizIds.first;
      final studentsData = await cubit.getStudentsForQuiz(quizId);

      if (studentsData.isEmpty) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      double totalScore = 0;
      int passedStudents = 0;

      // Normalize studentsData -> ensure each element is Map with required fields
      final students = <Map<String, dynamic>>[];

      for (final raw in studentsData) {
        // raw should be a Map<String, dynamic> coming from cubit
        final Map<String, dynamic> data = Map<String, dynamic>.from(raw);

        // Derive score percentage:
        double scorePercentage = 0.0;
        if (data.containsKey('averageScore') && data['averageScore'] != null) {
          final val = data['averageScore'];
          scorePercentage = (val is num) ? val.toDouble() : double.tryParse(val.toString()) ?? 0.0;
        } else {
          // fallback to (score / total) * 100
          final score = (data['score'] is num) ? (data['score'] as num).toDouble() : double.tryParse(data['score']?.toString() ?? '0') ?? 0.0;
          final total = (data['total'] is num) ? (data['total'] as num).toDouble() : double.tryParse(data['total']?.toString() ?? '1') ?? 1.0;
          if (total == 0) {
            scorePercentage = 0.0;
          } else {
            scorePercentage = (score / total) * 100.0;
          }
        }

        final status = (data['status']?.toString() ?? 'Fail');

        // Ensure we have studentId and studentName
        final studentId = data['studentId']?.toString() ?? data['uid']?.toString() ?? '';
        final studentName = data['studentName']?.toString() ?? data['name']?.toString() ?? 'Unknown';

        totalScore += scorePercentage;
        if (status.toLowerCase() == 'pass') passedStudents++;

        students.add({
          'id': studentId,
          'name': studentName,
          'score': scorePercentage,
          'status': status,
        });
      }

      if (mounted) {
        setState(() {
          quizStudents = students;
          averageScore = students.isNotEmpty ? totalScore / students.length : 0.0;
          passRate = students.isNotEmpty ? (passedStudents / students.length) * 100 : 0.0;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      debugPrint('Error loading quiz data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quiz data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      endDrawer: drawer(context),
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Performance Report',
            style: GoogleFonts.irishGrover(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildQuizSelector(widget.quizTitles, width),
            SizedBox(height: height * 0.03),
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.05),
                  child: const CircularProgressIndicator(
                    color: AppColors.primaryTeal,
                  ),
                ),
              )
            else if (quizStudents.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.05),
                  child: Text(
                    'No students data available',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
              )
            else ...[
              buildStatsCards(width, height),
              SizedBox(height: height * 0.03),
              buildStudentsTable(width, height),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildQuizSelector(List<String> quizzes, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Quiz',
          style: TextStyle(color: Colors.white, fontSize: width * 0.05),
        ),
        SizedBox(height: width * 0.02),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryTeal, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedQuiz,
              dropdownColor: const Color(0xFF1E293B),
              style: TextStyle(color: Colors.white, fontSize: width * 0.045),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primaryTeal,
                size: width * 0.06,
              ),
              items: quizzes.map((String title) {
                return DropdownMenuItem<String>(
                  value: title,
                  child: Text(title),
                );
              }).toList(),
              onChanged: (quiz) {
                if (quiz != null && quiz != selectedQuiz) {
                  setState(() {
                    selectedQuiz = quiz;
                  });
                  _loadQuizData(quiz);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStatsCards(double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryTeal, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  '${averageScore.toStringAsFixed(0)}%',
                  'Average Score',
                  const Color(0xffF5BBE7),
                  const Color(0xffF5BBE7),
                  width,
                  height,
                ),
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: buildStatCard(
                  '${passRate.toStringAsFixed(0)}%',
                  'Pass Rate',
                  const Color(0xff4DFF01),
                  const Color(0xff4DFF01),
                  width,
                  height,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          buildStatCard(
            '${quizStudents.length}',
            'Total Attempts',
            const Color(0xffE1FFA5),
            const Color(0xffE1FFA5),
            width * .9,
            height,
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(
    String value,
    String label,
    Color labelColor,
    Color valueColor,
    double width,
    double height,
  ) {
    return Container(
      width: width,
      height: height * 0.15,
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryTeal, width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: width * 0.08,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            label,
            style: TextStyle(color: labelColor, fontSize: width * 0.035),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildStudentsTable(double width, double height) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryTeal, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              border: Border(bottom: BorderSide(color: AppColors.primaryTeal)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Student',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(width: width * 0.06), // space for chat icon column
              ],
            ),
          ),
          ...quizStudents.map(
            (student) => _buildStudentRow(student, width, height),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> student, double width, double height) {
    final studentName = student['name']?.toString() ?? 'Unknown';
    final studentScore = (student['score'] is num) ? (student['score'] as num).toDouble() : double.tryParse(student['score']?.toString() ?? '0') ?? 0.0;
    final studentStatus = student['status']?.toString() ?? 'Fail';
    final studentId = student['id']?.toString() ?? '';

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          // Student Name
          Expanded(
            flex: 3,
            child: Text(
              studentName,
              style: TextStyle(color: Colors.white, fontSize: width * 0.035),
            ),
          ),

          // Score
          Expanded(
            flex: 2,
            child: Text(
              '${studentScore.toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: width * 0.035),
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: Text(
              studentStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: studentStatus.toLowerCase() == 'pass' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),

          // Chat button (teacher -> student)
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryTeal),
            onPressed: () async {
              if (selectedQuiz == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No quiz selected'), backgroundColor: Colors.red),
                );
                return;
              }

              final cubit = context.read<CreateQuizCubit>();
              final quizIds = await cubit.getQuiz(widget.uid, selectedQuiz!);

              if (quizIds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Quiz ID not found for this chat"), backgroundColor: Colors.red),
                );
                return;
              }

              final quizId = quizIds.first;
              final teacherId = FirebaseAuth.instance.currentUser!.uid;

              if (studentId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Student ID not available"), backgroundColor: Colors.red),
                );
                return;
              }

              // Navigate to ChatScreen and provide ChatCubit if not provided globally
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) => ChatCubit(ChatRepository()),
                    child: ChatScreen(
                      quizId: quizId,
                      studentId: studentId,
                      teacherId: teacherId,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget drawer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: AppColors.secondaryBackground,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryTeal,
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.08,
                  width: screenHeight * 0.08,
                  child: Image.asset(AppConstants.brainLogo),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "QUIZLY",
                  style: TextStyle(
                    color: AppColors.secondaryTeal,
                    fontSize: screenWidth * 0.085,
                    fontFamily: "DMSerifDisplay",
                  ),
                ),
              ],
            ),
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WrapperTeacherPage()),
            ),
            context,
            const Icon(Icons.home_outlined, color: AppColors.secondaryTeal),
            "Home",
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 1),
              ),
            ),
            context,
            const Icon(Icons.person_outlined, color: AppColors.secondaryTeal),
            "Profile",
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 2),
              ),
            ),
            context,
            const Icon(Icons.list, color: AppColors.secondaryTeal),
            "My Quizzes",
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryTeal,
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.settings, color: AppColors.secondaryTeal),
              title: Text(
                "Setting",
                style: TextStyle(
                  color: AppColors.secondaryTeal,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WrapperTeacherPage(index: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listtitle(
    Function callback,
    BuildContext context,
    Icon icon,
    String txt,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryTeal,
            width: screenHeight * 0.001,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        leading: icon,
        title: Text(
          txt,
          style: TextStyle(
            color: AppColors.secondaryTeal,
            fontSize: screenWidth * 0.06,
          ),
        ),
        onTap: () => callback(),
      ),
    );
  }
}
