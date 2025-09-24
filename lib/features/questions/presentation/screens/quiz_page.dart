import 'dart:async';

import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/widget/page_component.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  static const String id = '/quiz-page';

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool showResult = false;

  List<String> questions = [
    "What is Flutter?",
    "What is Dart?",
    "What is State Management?",
    "How are you?",
    "Where is India?",
    "What is your name?",
  ];

  // Fixed the Map structure - each question should have its own key
  Map<int, List<String>> answers = {
    0: [
      "A programming language",
      "A UI toolkit",
      "A database",
      "An operating system",
    ],
    1: [
      "A programming language",
      "A UI toolkit",
      "A database",
      "An operating system",
    ],
    2: [
      "A programming language",
      "A database",
      "A way to manage state",
      "An operating system",
    ],
    3: ["I'm fine, thank you!", "I'm sad", "I'm angry", "I'm happy"],
    4: ["In Asia", "In Europe", "In America", "In Africa"],
    5: [
      "My name is FlutterBot",
      "My name is DartBot",
      "My name is StateBot",
      "My name is Ahmed",
    ],
  };

  // Correct answers index for each question
  Map<int, int> correctAnswers = {0: 1, 2: 2, 3: 0, 4: 0, 5: 3};

  // Timer variables
  Timer? _timer;
  int _timeLeft = 60; // 60 seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorApp.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: height / 24),
            LinearProgressIndicator(
              backgroundColor: ColorApp.textFieldBackgroundColor.withOpacity(
                0.5,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(16),
              value: (currentQuestionIndex + 1).toDouble() / questions.length,
              valueColor: AlwaysStoppedAnimation<Color>(ColorApp.whiteColor),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1} of ${questions.length}',
                ),
                Spacer(),
                Text('${_timeLeft}s'),
              ],
            ),
            SizedBox(height: height / 12.6),
            Expanded(
              child: PageComponent(
                question: questions[currentQuestionIndex],
                numOfQuestion: "${currentQuestionIndex + 1}",
                selectedAnswers: answers[currentQuestionIndex]!,
                correctAnswerIndex: correctAnswers[currentQuestionIndex]!,
                onAnswerSelected: (int index) {
                  setState(() {
                    selectedAnswerIndex = index;
                    showResult = true;
                  });
                },
                selectedAnswerIndex: selectedAnswerIndex,
                showResult: showResult,
              ),
            ),
            Row(
              children: [
                // Previous button
                ElevatedButton(
                  onPressed:
                      currentQuestionIndex > 0
                          ? () {
                            setState(() {
                              currentQuestionIndex--;
                              selectedAnswerIndex = null;
                              showResult = false;
                            });
                          }
                          : null, // Disabled عند أول سؤال
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          states.contains(MaterialState.disabled)
                              ? ColorApp.primaryButtonColor.withOpacity(0.5)
                              : ColorApp.primaryButtonColor,
                    ),
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        horizontal: width / 11.8,
                        vertical: height / 25.1,
                      ),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorApp.greyColor,
                    size: 35,
                  ),
                ),

                Spacer(),

                // Next button
                ElevatedButton(
                  onPressed:
                      currentQuestionIndex < questions.length - 1
                          ? () {
                            setState(() {
                              currentQuestionIndex++;
                              selectedAnswerIndex = null;
                              showResult = false;
                            });
                          }
                          : null, // Disabled عند آخر سؤال
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          states.contains(MaterialState.disabled)
                              ? ColorApp.primaryButtonColor.withOpacity(0.5)
                              : ColorApp.primaryButtonColor,
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ),
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        horizontal: width / 11.8,
                        vertical: height / 25.1,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: ColorApp.greyColor,
                    size: 35,
                  ),
                ),
              ],
            ),
            if (currentQuestionIndex == questions.length - 1) ...[
              SizedBox(height: height / 25.25),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    ColorApp.primaryButtonColor,
                  ),
                  minimumSize: MaterialStatePropertyAll(
                    Size(width / 1.15, height / 16.9),
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: Text(
                  "Submit Quiz",
                  style: TextStyle(
                    color: AppColors.hint,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
