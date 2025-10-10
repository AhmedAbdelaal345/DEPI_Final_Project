// screens/profile_screen.dart
// 
// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
// import 'package:iconify_flutter/icons/arcticons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Map<String, List<Map<String, String>>> subjects = const {
    "Math": [
      {"title": "Math Basics", "date": "23/9/2025", "score": "80%"},
      {"title": "Math1", "date": "12/9/2025", "score": "76%"},
      {"title": "Math2", "date": "10/9/2025", "score": "83%"},
    ],
    "Physics": [
      {"title": "Physics Basics", "date": "20/9/2025", "score": "78%"},
      {"title": "Physics1", "date": "15/9/2025", "score": "72%"},
    ],
    "Programming 1": [
      {"title": "Intro to C++", "date": "18/9/2025", "score": "88%"},
      {"title": "Data Structures", "date": "14/9/2025", "score": "90%"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
   
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    
    const designWidth = 390.0;
    const designHeight = 844.0;
    
   
    final widthRatio = screenWidth / designWidth;
    final heightRatio = screenHeight / designHeight;
    
    int totalQuizzes = subjects.values
        .map((quizList) => quizList.length)
        .reduce((a, b) => a + b);

    
    int totalSubjects = subjects.length;

    List<int> allScores = [];
    subjects.values.forEach((quizList) {
      quizList.forEach((quiz) {
        allScores.add(int.parse(quiz["score"]!.replaceAll("%", "")));
      });
    });
    int averageScore = (allScores.reduce((a, b) => a + b) / allScores.length).round();
    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000920),
        elevation: 0,
        title:  Text(l10n.profile, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 91 * heightRatio),
            Stack(
              alignment: Alignment.center,
              children: [
               
                Positioned(
                  top: 0,
                  bottom: 100 * heightRatio,
                  child: CustomPaint(
                    size: Size(2 * widthRatio, 200 * heightRatio),
                    painter: DashedLinePainter(widthRatio: widthRatio),
                  ),
                ),
                Container(
                  width: 152 * widthRatio,
                  height: 152 * heightRatio,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile_image.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.pets,
                            size: 80 * widthRatio,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5 * heightRatio),
            Text(
              "Yamen magdy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24 * widthRatio,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4 * heightRatio),
            Text(
              "yamenmagdy222@gmail.com",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14 * widthRatio,
              ),
            ),
            SizedBox(height: 32 * heightRatio),
            Padding(
              padding: EdgeInsets.only(
                left: 37 * widthRatio,
                right: 36 * widthRatio,
              ),
              child: Column(
                children: [
                  _buildStatCard(
                    icon: Icons.list,
                    label: "All Quizzes taken",
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
            SizedBox(height: 20 * heightRatio),
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


class DashedLinePainter extends CustomPainter {
  final double widthRatio;
  
  DashedLinePainter({required this.widthRatio});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2 * widthRatio
      ..style = PaintingStyle.stroke;

    final dashWidth = 5.0 * widthRatio;
    final dashSpace = 5.0 * widthRatio;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
