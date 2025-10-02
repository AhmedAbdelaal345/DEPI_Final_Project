import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:flutter/material.dart';
class PageComponent extends StatelessWidget {
  const PageComponent({
    super.key,
    required this.question,
    required this.numOfQuestion,
    required this.selectedAnswers,
    required this.correctAnswerIndex,
    required this.onAnswerSelected,
    this.selectedAnswerIndex,
    this.showResult = false,
  });

  final String question;
  final String numOfQuestion;
  final List<String> selectedAnswers;
  final int correctAnswerIndex;
  final Function(int) onAnswerSelected;
  final int? selectedAnswerIndex;
  final bool showResult;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.tealHighlight, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Q${numOfQuestion} : ",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.card,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: width / 84.5),
                  Expanded(
                    child: Text(
                      "${question} ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.card,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: height / 23),
          ...selectedAnswers.asMap().entries.map((entry) {
            int index = entry.key;
            String answer = entry.value;
            return _answerContainer(
              context,
              width, 
              answer, 
              index,
            );
          }).toList(),
          SizedBox(height: height / 23),
        ],
      ),
    );
  }

  Widget _answerContainer(
    BuildContext context,
    double width, 
    String answer, 
    int index,
  ) {
    Color? backgroundColor;
    Color? textColor = AppColors.card;
    
    if (showResult && selectedAnswerIndex != null) {
      if (index == correctAnswerIndex) {
        backgroundColor = Colors.green.withOpacity(0.3);
        textColor = Colors.green[800];
      } else if (index == selectedAnswerIndex && index != correctAnswerIndex) {
        // Wrong selected answer - red
        backgroundColor = Colors.red.withOpacity(0.3);
        textColor = Colors.red[800];
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: showResult ? null : () => onAnswerSelected(index),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: selectedAnswerIndex == index 
                ? AppColors.tealHighlight 
                : Colors.grey.withOpacity(0.3),
              width: selectedAnswerIndex == index ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: selectedAnswerIndex,
                onChanged: showResult ? null : (int? value) {
                  if (value != null) {
                    onAnswerSelected(value);
                  }
                },
                activeColor: showResult 
                  ? (index == correctAnswerIndex ? Colors.green : Colors.red)
                  : AppColors.tealHighlight,
              ),
              SizedBox(width: width / 84.5),
              Expanded(
                child: Text(
                  answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showResult && index == correctAnswerIndex)
                Icon(Icons.check, color: Colors.green, size: 20),
              if (showResult && index == selectedAnswerIndex && index != correctAnswerIndex)
                Icon(Icons.close, color: Colors.red, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}