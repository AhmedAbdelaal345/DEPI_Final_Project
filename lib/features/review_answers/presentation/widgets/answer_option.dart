import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_app.dart';
import '../../../home/presentation/widgets/app_constants.dart';
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

    final int optionIndex = question.options.indexOf(optionText);

    final bool isCorrect = optionIndex == question.correctAnswerIndex;
    final bool isSelected = optionIndex == question.userAnswerIndex;

    Color borderColor = AppColors.bg; // لون افتراضي للإطار
    Color containerColor = AppColors.bg; // لون افتراضي للخلفية
    IconData? icon; // أيقونة لتوضيح الصح والخطأ
    Color iconColor = AppColors.bg;

    if (isCorrect) {
      containerColor  = const Color(0xff0d3a1c);
      borderColor = Colors.green;
      iconColor = Colors.green;
    } else if (isSelected) {
      containerColor  = const Color(0xff200001);
      borderColor = Colors.red;
      iconColor = Colors.red;
    }


    return  Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: containerColor,
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
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}