import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/wrapper_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  List<dynamic> quizStudents = [];
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
    });

    try {
      final cubit = context.read<CreateQuizCubit>();

      final quizIds = await cubit.getQuiz(widget.uid, quizTitle);

      if (quizIds.isNotEmpty) {
        final quizId = quizIds.first;
        final studentsData = await cubit.getStudentsForQuiz(quizId);

        if (studentsData.isNotEmpty) {
          double totalScore = 0;
          int passedStudents = 0;

          final students =
              studentsData.map((data) {
                // Use percentage (0-100). Prefer value provided by cubit; fallback to compute from score/total.
                final double scorePercentage = (
                  (data['averageScore'] ??
                      (((data['total'] ?? 0) == 0)
                          ? 0.0
                          : ((data['score'] ?? 0) / (data['total'] ?? 1) * 100)))
                ).toDouble();
                final status = data['status'] ?? 'Fail';

                totalScore += scorePercentage;
                if (status == 'Pass') passedStudents++;

                return (
                  name: data['studentName'] ?? 'Unknown',
                  score: scorePercentage,
                  status: status,
                );
              }).toList();

          if (mounted) {
            setState(() {
              quizStudents = students;
              averageScore =
                  students.isNotEmpty ? totalScore / students.length : 0.0;
              passRate =
                  students.isNotEmpty
                      ? (passedStudents / students.length) * 100
                      : 0.0;
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
        title: Text(
          'Performance Report',
          style: TextStyle(
            fontFamily: 'Judson',
            color: Colors.white,
            fontSize: width * 0.065,
          ),
        ),
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
                    color: Color(0xff4FB3B7),
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
            border: Border.all(color: const Color(0xff4FB3B7), width: 2),
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
                color: const Color(0xff4FB3B7),
                size: width * 0.06,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: width * 0.03,
              ),
              items:
                  quizzes.map((String title) {
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
      // Remove fixed height to avoid overflow on small screens
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff4FB3B7), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      // Remove fixed height to allow content to dictate size
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff4FB3B7), width: 3),
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
        border: Border.all(color: const Color(0xff4FB3B7), width: 2),
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
              border: Border(bottom: BorderSide(color: Color(0xff4FB3B7))),
            ),
            child: Row(
              children: [
                Expanded(
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

  Widget _buildStudentRow(dynamic student, double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              student.name,
              style: TextStyle(color: Colors.white, fontSize: width * 0.035),
            ),
          ),
          Expanded(
            child: Text(
              '${student.score.toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: width * 0.035),
            ),
          ),
          Expanded(
            child: Text(
              student.status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: student.status == 'Pass' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: const Color(0xff061438),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xff061438),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xff4FB3B7),
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.08,
                  width: screenHeight * 0.08,
                  child: Image.asset("assets/images/brain_logo.png"),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "QUIZLY",
                  style: TextStyle(
                    color: const Color(0xff62DDE1),
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
            const Icon(Icons.home_outlined, color: Color(0xff62DDE1)),
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
            const Icon(Icons.person_outlined, color: Color(0xff62DDE1)),
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
            const Icon(Icons.list, color: Color(0xff62DDE1)),
            "My Quizzes",
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xff4FB3B7),
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.settings, color: Color(0xff62DDE1)),
              title: Text(
                "Setting",
                style: TextStyle(
                  color: const Color(0xff62DDE1),
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
            color: const Color(0xff4FB3B7),
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
            color: const Color(0xff62DDE1),
            fontSize: screenWidth * 0.06,
          ),
        ),
        onTap: () => callback(),
      ),
    );
  }
}
