import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

class QuizTitleBar extends StatelessWidget {
  const QuizTitleBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sy(context, 64),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: sx(context, 65),
              height: sx(context, 65),
              child: Image.asset(
                'assets/images/brain_logo.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6A5ACD),
                          Color(0xFF00B4D8),
                          Color(0xFFFF7EB3),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: sx(context, 10)),
          Text(
            title,
            style: GoogleFonts.irishGrover(
              fontSize: sx(context, 28),
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
