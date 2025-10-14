import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashed_line_painter.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final double widthRatio;
  final double heightRatio;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.widthRatio,
    required this.heightRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60 * heightRatio),
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
              width: 135 * widthRatio,
              height: 135 * widthRatio,
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
                        Icons.person,
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
          fullName,
          style: GoogleFonts.judson(
            color: Colors.white,
            fontSize: 24 * widthRatio,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4 * heightRatio),
        Text(
          email,
          style: GoogleFonts.judson(
            color: Colors.white70,
            fontSize: 20 * widthRatio,
          ),
        ),
      ],
    );
  }
}