import 'dart:async';
import 'dart:developer' as developer;

import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/features/questions/presentation/widget/page_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, this.quizId});
  static const String id = '/quiz-page';
  final String? quizId;
  
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool showResult = false;
  Map<int, int> userAnswers = {};
  Timer? _timer;
  int _timeLeft = 60;
  String? _currentQuizId;

  @override
  void initState() {
    super.initState();
    // Debug: طباعة معلومات أولية
    developer.log('QuizPage initState called');
    developer.log('Widget quizId: ${widget.quizId}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Debug: طباعة معلومات Route
    final route = ModalRoute.of(context);
    developer.log('Route: ${route?.settings.name}');
    developer.log('Route arguments: ${route?.settings.arguments}');
    
    // جرب كل الطرق الممكنة لجلب الـ Quiz ID
    final String? routeQuizId = route?.settings.arguments as String?;
    _currentQuizId = routeQuizId ?? widget.quizId ?? "1"; // استخدم "1" كـ fallback
    
    developer.log('Final quizId used: $_currentQuizId');
    
    if (_currentQuizId != null && _currentQuizId!.isNotEmpty) {
      developer.log('Calling getQuestions with ID: $_currentQuizId');
      context.read<QuizCubit>().getQuestions(_currentQuizId!);
      _startTimer();
    } else {
      developer.log('ERROR: No quiz ID available');
      _showErrorAndGoBack('No Quiz ID provided');
    }
  }

  void _showErrorAndGoBack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _submitQuiz(context.read<QuizCubit>().state);
          }
        });
      }
    });
  }

  int _mapAnswerToIndex(String correctKey, Map<String, String> options) {
    // Convert correct key to uppercase since Firestore has "A", "B", "C", "D"
    final upperCorrectKey = correctKey.toUpperCase();
    final keys = options.keys.toList();
    
    // Sort keys to ensure consistent order (A, B, C, D)
    keys.sort();
    
    final index = keys.indexOf(upperCorrectKey);
    developer.log('Mapping answer: $correctKey ($upperCorrectKey) -> index: $index');
    developer.log('Available keys: $keys');
    
    return index >= 0 ? index : 0; // Return 0 if not found instead of -1
  }

  void _submitQuiz(QuizState state) {
    developer.log('Submitting quiz, current state: ${state.runtimeType}');
    
    if (state is! LoadedState || !mounted) {
      developer.log('Cannot submit quiz - invalid state or not mounted');
      return;
    }
    
    int correctCount = 0;
    int wrongCount = 0;
    final questions = state.questions;
    
    developer.log('Total questions: ${questions.length}');
    developer.log('User answers: $userAnswers');
    
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers.containsKey(i)) {
        final correctAnswerIndex = _mapAnswerToIndex(
          questions[i].correctAnswer,
          questions[i].options,
        );
        if (userAnswers[i] == correctAnswerIndex) {
          correctCount++;
          developer.log('Question $i: CORRECT');
        } else {
          wrongCount++;
          developer.log('Question $i: WRONG (user: ${userAnswers[i]}, correct: $correctAnswerIndex)');
        }
      } else {
        wrongCount++;
        developer.log('Question $i: UNANSWERED');
      }
    }

    developer.log('Final results: $correctCount correct, $wrongCount wrong');
    
    double accuracy = questions.isNotEmpty ? correctCount / questions.length : 0.0;
    
    QuizResult result = QuizResult(
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      wrongAnswers: wrongCount,
      accuracy: accuracy,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(quizResult: result),
      ),
    );
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
      appBar: AppBar(
        title: Text('Quiz ID: $_currentQuizId', style: TextStyle(fontSize: 14)),
        backgroundColor: ColorApp.backgroundColor,
        foregroundColor: ColorApp.whiteColor,
      ),
      body: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          developer.log('BlocListener: State changed to ${state.runtimeType}');
          
          if (state is ErrorState) {
            developer.log('ERROR STATE: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ERROR: ${state.error}'),
                backgroundColor: AppColors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          } else if (state is LoadedState) {
            developer.log('LOADED STATE: ${state.questions.length} questions loaded');
          }
        },
        builder: (context, state) {
          developer.log('BlocBuilder: Building with state ${state.runtimeType}');

          if (state is LoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: ColorApp.primaryButtonColor),
                  const SizedBox(height: 16),
                  Text(
                    'Loading Quiz ID: $_currentQuizId...',
                    style: TextStyle(color: ColorApp.whiteColor, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      developer.log('Manual retry requested');
                      if (_currentQuizId != null) {
                        context.read<QuizCubit>().getQuestions(_currentQuizId!);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Quiz Loading Failed',
                      style: TextStyle(
                        color: ColorApp.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quiz ID: $_currentQuizId',
                      style: TextStyle(color: Colors.yellow, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${state.error}',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            developer.log('Retry button pressed');
                            if (_currentQuizId != null) {
                              context.read<QuizCubit>().getQuestions(_currentQuizId!);
                            }
                          },
                          child: const Text('Retry'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            developer.log('Go Back button pressed');
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Debug info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Debug Info:', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
                          Text('Widget ID: ${widget.quizId}', style: TextStyle(color: Colors.white, fontSize: 12)),
                          Text('Route Args: ${ModalRoute.of(context)?.settings.arguments}', style: TextStyle(color: Colors.white, fontSize: 12)),
                          Text('Used ID: $_currentQuizId', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! LoadedState || state.questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, size: 64, color: ColorApp.greyColor),
                  const SizedBox(height: 16),
                  Text(
                    'No Questions Available',
                    style: TextStyle(color: ColorApp.whiteColor, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quiz ID: $_currentQuizId',
                    style: TextStyle(color: Colors.yellow, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Progress and info
                  LinearProgressIndicator(
                    backgroundColor: ColorApp.textFieldBackgroundColor.withOpacity(0.5),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(16),
                    value: (currentQuestionIndex + 1).toDouble() / state.questions.length,
                    valueColor: AlwaysStoppedAnimation<Color>(ColorApp.whiteColor),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Text(
                        'Q${currentQuestionIndex + 1}/${state.questions.length}',
                        style: TextStyle(color: ColorApp.whiteColor),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _timeLeft <= 10 ? Colors.red.withOpacity(0.2) : ColorApp.primaryButtonColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_timeLeft}s',
                          style: TextStyle(
                            color: _timeLeft <= 10 ? Colors.red : ColorApp.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 12.6),
                  
                  // Question
                  Expanded(
                    child: PageComponent(
                      question: state.questions[currentQuestionIndex].text.toString(),
                      numOfQuestion: "${currentQuestionIndex + 1}",
                      selectedAnswers: state.questions[currentQuestionIndex].options.values.toList(),
                      correctAnswerIndex: _mapAnswerToIndex(
                        state.questions[currentQuestionIndex].correctAnswer,
                        state.questions[currentQuestionIndex].options,
                      ),
                      onAnswerSelected: (int index) {
                        developer.log('Answer selected: $index for question $currentQuestionIndex');
                        setState(() {
                          selectedAnswerIndex = index;
                          showResult = true;
                          userAnswers[currentQuestionIndex] = index;
                        });
                      },
                      selectedAnswerIndex: selectedAnswerIndex,
                      showResult: showResult,
                    ),
                  ),
                  
                  // Navigation buttons (Previous and Next)
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: currentQuestionIndex > 0
                            ? () {
                                setState(() {
                                  currentQuestionIndex--;
                                  selectedAnswerIndex = userAnswers[currentQuestionIndex];
                                  showResult = selectedAnswerIndex != null;
                                });
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => states.contains(MaterialState.disabled)
                                ? ColorApp.primaryButtonColor.withOpacity(0.5)
                                : ColorApp.primaryButtonColor,
                          ),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: width / 11.8, vertical: height / 25.1),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: ColorApp.greyColor, size: 35),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: currentQuestionIndex < state.questions.length - 1
                            ? () {
                                setState(() {
                                  currentQuestionIndex++;
                                  selectedAnswerIndex = userAnswers[currentQuestionIndex];
                                  showResult = selectedAnswerIndex != null;
                                });
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => states.contains(MaterialState.disabled)
                                ? ColorApp.primaryButtonColor.withOpacity(0.5)
                                : ColorApp.primaryButtonColor,
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(120)),
                          ),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: width / 11.8, vertical: height / 25.1),
                          ),
                        ),
                        child: Icon(Icons.arrow_forward_rounded, color: ColorApp.greyColor, size: 35),
                      ),
                    ],
                  ),
                  
                  // Submit button
                  if (currentQuestionIndex == state.questions.length - 1) ...[
                    SizedBox(height: height / 25.25),
                    SizedBox(
                      width: width / 1.15,
                      height: height / 16.9,
                      child: ElevatedButton(
                        onPressed: () => _submitQuiz(state),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(ColorApp.primaryButtonColor),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}