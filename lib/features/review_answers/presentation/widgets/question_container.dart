import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionContainer extends StatelessWidget {
  final String questionText;
  final String id;

  const QuestionContainer({
    super.key,
    required this.questionText,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Text(
        '${int.parse(id)+1} : $questionText',
        textAlign: TextAlign.center,
        style: GoogleFonts.judson(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}