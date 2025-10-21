// profile_screen.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   Future<Map<String, dynamic>?> getUserData() async {
//     // هنا بتحمّل بيانات أول مستخدم من collection اسمها users
//     final snapshot = await FirebaseFirestore.instance.collection('users').get();

//     if (snapshot.docs.isNotEmpty) {
//       return snapshot.docs.first.data();
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     const designWidth = 390.0;
//     const designHeight = 844.0;

//     final widthRatio = screenWidth / designWidth;
//     final heightRatio = screenHeight / designHeight;

//     return Scaffold(
//       backgroundColor: const Color(0xFF000920),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.cyanAccent),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(
//               child: Text("No user data found",
//                   style: TextStyle(color: Colors.white)),
//             );
//           }

//           final user = snapshot.data!;
//           final name = user['fullName'] ?? 'No Name';
//           final email = user['email'] ?? 'No Email';
//           final imageUrl = user['profilePicture'] ?? '';

//           // بيانات تجريبية مؤقتة
//           final totalQuizzes = 8;
//           final totalSubjects = 3;
//           final averageScore = 85;

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 91 * heightRatio),
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Positioned(
//                       top: 0,
//                       bottom: 100 * heightRatio,
//                       child: CustomPaint(
//                         size: Size(2 * widthRatio, 200 * heightRatio),
//                         painter: DashedLinePainter(widthRatio: widthRatio),
//                       ),
//                     ),
//                     Container(
//                       width: 152 * widthRatio,
//                       height: 152 * heightRatio,
//                       decoration: const BoxDecoration(shape: BoxShape.circle),
//                       child: ClipOval(
//                         child: imageUrl.isNotEmpty
//                             ? Image.network(imageUrl, fit: BoxFit.cover)
//                             : Icon(Icons.person,
//                                 size: 60 * widthRatio, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5 * heightRatio),
//                 Text(
//                   name,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24 * widthRatio,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4 * heightRatio),
//                 Text(
//                   email,
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14 * widthRatio,
//                   ),
//                 ),
//                 SizedBox(height: 32 * heightRatio),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: 37 * widthRatio,
//                     right: 36 * widthRatio,
//                   ),
//                   child: Column(
//                     children: [
//                       _buildStatCard(
//                         imagePath: 'assets/lists.png',
//                         label: "All Quizzes taken",
//                         value: totalQuizzes.toString(),
//                         widthRatio: widthRatio,
//                         heightRatio: heightRatio,
//                       ),
//                       SizedBox(height: 20 * heightRatio),
//                       _buildStatCard(
//                         imagePath: 'assets/books.png',
//                         label: "Subjects",
//                         value: totalSubjects.toString(),
//                         widthRatio: widthRatio,
//                         heightRatio: heightRatio,
//                       ),
//                       SizedBox(height: 16 * heightRatio),
//                       _buildStatCard(
//                         imagePath: 'assets/scorehero.png',
//                         label: "Average Score",
//                         value: "$averageScore%",
//                         widthRatio: widthRatio,
//                         heightRatio: heightRatio,
//                         isLast: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20 * heightRatio),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required String imagePath,
//     required String label,
//     required String value,
//     required double widthRatio,
//     required double heightRatio,
//     bool isLast = false,
//   }) {
//     return Container(
//       width: 317 * widthRatio,
//       height: isLast ? 89 * heightRatio : 82 * heightRatio,
//       padding: EdgeInsets.symmetric(
//         horizontal: 20 * widthRatio,
//         vertical: 16 * heightRatio,
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xFF000B27),
//         border: Border.all(
//           color: const Color(0xFF5AC7C7),
//           width: 1 * widthRatio,
//         ),
//         borderRadius: BorderRadius.circular(10 * widthRatio),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             imagePath,
//             width: 28 * widthRatio,
//             height: 28 * widthRatio,
//             color: Colors.white,
//             fit: BoxFit.contain,
//           ),
//           SizedBox(width: 16 * widthRatio),
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16 * widthRatio,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24 * widthRatio,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DashedLinePainter extends CustomPainter {
//   final double widthRatio;

//   DashedLinePainter({required this.widthRatio});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.3)
//       ..strokeWidth = 2 * widthRatio
//       ..style = PaintingStyle.stroke;

//     final dashWidth = 5.0 * widthRatio;
//     final dashSpace = 5.0 * widthRatio;
//     double startY = 0;

//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(size.width / 2, startY),
//         Offset(size.width / 2, startY + dashWidth),
//         paint,
//       );
//       startY += dashWidth + dashSpace;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, dynamic>?> getUserData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder for responsive sizing
    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("No user data found",
                    style: TextStyle(color: Colors.white)),
              );
            }

            final user = snapshot.data!;
            final name = user['fullName'] ?? 'No Name';
            final email = user['email'] ?? 'No Email';
            final imageUrl = user['profilePicture'] ?? '';

            // temporary placeholders (you can compute these from Firestore if you store quizzes)
            final totalQuizzes = 8;
            final totalSubjects = 3;
            final averageScore = 85;

            return LayoutBuilder(builder: (context, constraints) {
              // base design: 390x844 -> compute ratio but cap extremes
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              const designWidth = 390.0;
              const designHeight = 844.0;

              // clamp ratios so UI doesn't blow up on very large screens
              final widthRatio =
                  (screenWidth / designWidth).clamp(0.6, 1.4); // min/max scale
              final heightRatio =
                  (screenHeight / designHeight).clamp(0.6, 1.4);

              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 24 * heightRatio),
                child: Column(
                  children: [
                    SizedBox(height: 32 * heightRatio),
                    // Avatar + dashed line area
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // dashed line vertical - make it taller but centered
                        Positioned(
                          top: 0,
                          bottom: 0,
                          child: SizedBox(
                            height: 200 * heightRatio,
                            width: 20 * widthRatio,
                            child: CustomPaint(
                              painter: DashedLinePainter(widthRatio: widthRatio),
                            ),
                          ),
                        ),

                        // Avatar
                        Container(
                          width: 152 * widthRatio,
                          height: 152 * widthRatio, // make it square for web consistency
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            // optional: border or shadow
                          ),
                          child: ClipOval(
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      // fallback to local placeholder or icon
                                      return Container(
                                        color: Colors.grey[850],
                                        child: Icon(
                                          Icons.person,
                                          size: 60 * widthRatio,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[850],
                                    child: Icon(
                                      Icons.person,
                                      size: 60 * widthRatio,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10 * heightRatio),

                    // Name
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * widthRatio),
                      child: Column(
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24 * widthRatio,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6 * heightRatio),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14 * widthRatio,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28 * heightRatio),

                    // Stats cards
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * widthRatio,
                      ),
                      child: Column(
                        children: [
                          // All quizzes
                          _buildStatCard(
                            imagePath: 'assets/lists.png',
                            label: "All Quizzes taken",
                            value: totalQuizzes.toString(),
                            widthRatio: widthRatio,
                            heightRatio: heightRatio,
                          ),
                          SizedBox(height: 16 * heightRatio),

                          // Subjects
                          _buildStatCard(
                            imagePath: 'assets/books.png',
                            label: "Subjects",
                            value: totalSubjects.toString(),
                            widthRatio: widthRatio,
                            heightRatio: heightRatio,
                          ),
                          SizedBox(height: 16 * heightRatio),

                          // Average
                          _buildStatCard(
                            imagePath: 'assets/scorehero.png',
                            label: "Average Score",
                            value: "$averageScore%",
                            widthRatio: widthRatio,
                            heightRatio: heightRatio,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28 * heightRatio),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String imagePath,
    required String label,
    required String value,
    required double widthRatio,
    required double heightRatio,
    bool isLast = false,
  }) {
    // cardWidth will be flexible; we give internal paddings and make right side number fixed width
    return LayoutBuilder(builder: (context, constraints) {
      final cardHeight = isLast ? 92 * heightRatio : 82 * heightRatio;
      final rightBoxWidth = 70 * widthRatio;

      return Container(
        height: cardHeight,
        padding: EdgeInsets.symmetric(
          horizontal: 14 * widthRatio,
          vertical: 8 * heightRatio,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF000B27),
          border: Border.all(
            color: const Color(0xFF5AC7C7),
            width: 1 * widthRatio,
          ),
          borderRadius: BorderRadius.circular(12 * widthRatio),
        ),
        child: Row(
          children: [
            // left icon with safe fallback if asset missing
            SizedBox(
              width: 36 * widthRatio,
              height: 36 * widthRatio,
              child: _safeAssetImage(imagePath, widthRatio),
            ),
            SizedBox(width: 12 * widthRatio),

            // label (wraps)
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15 * widthRatio,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // right value box
            SizedBox(width: 12 * widthRatio),
            Container(
              width: rightBoxWidth,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * widthRatio,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _safeAssetImage(String assetPath, double widthRatio) {
    // Try to load asset; if missing show a generic icon
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      // color: Colors.white, // avoid forcing color if icon is colorful
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6 * widthRatio),
          ),
          child: Icon(
            Icons.grid_view_rounded,
            color: Colors.white70,
            size: 24 * widthRatio,
          ),
        );
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double widthRatio;

  DashedLinePainter({required this.widthRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..strokeWidth = 2 * widthRatio
      ..style = PaintingStyle.stroke;

    final dashWidth = 6.0 * widthRatio;
    final dashSpace = 6.0 * widthRatio;
    double startY = 0;

    final centerX = size.width / 2;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(centerX, startY),
        Offset(centerX, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
