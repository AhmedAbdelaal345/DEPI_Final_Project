import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_app.dart';
import '../../domain/entities/review_question.dart';

class AnswerOption extends StatelessWidget {
  final String optionText;
  final ReviewQuestion question;

  const AnswerOption({
    super.key,
    required this.optionText,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isCorrectAnswer = optionText == question.correctAnswer;
    final bool wasSelectedByUser = optionText == question.userAnswer;

    Color borderColor = ColorApp.backgroundColor;
    Color iconColor = ColorApp.backgroundColor;
    Color containerbackgroundColor = ColorApp.backgroundColor;

    if (isCorrectAnswer) {
      containerbackgroundColor = const Color(0xff0d3a1c);
      borderColor = Colors.green;
      iconColor = Colors.green;
    } else if (wasSelectedByUser) {
      containerbackgroundColor = const Color(0xff200001);
      borderColor = Colors.red;
      iconColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: containerbackgroundColor,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding:  EdgeInsets.all(screenWidth * 0.003), // المسافة بين الأيقونة والبوردر
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorApp.backgroundColor, // لون الخلفية (الداخلي)
              border: Border.all(
                color: Colors.cyan, // اللون الخارجي (الإطار)
                width: 2,           // سُمك الإطار
              ),
            ),
            child: Icon(
              Icons.circle,
              color: iconColor,
              size: screenWidth * 0.04,
            ),
          ),
          SizedBox(width: screenWidth * 0.05),
          Expanded(
            child: Text(
              optionText,
              style: GoogleFonts.judson(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}