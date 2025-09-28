import 'dart:async';
import 'dart:developer' as developer;
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/features/questions/presentation/widget/page_component.dart';
import 'package:depi_final_project/features/review_answers/domain/entities/review_question.dart';
import 'package:depi_final_project/features/review_answers/domain/repositories/review_repositories_implimentation.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_cubit.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    developer.log('QuizPage initState called');
    developer.log('Widget quizId: ${widget.quizId}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only initialize once
    if (_isInitialized) return;
    _isInitialized = true;

    developer.log('QuizPage didChangeDependencies called');

    // Get quiz ID from multiple sources
    final route = ModalRoute.of(context);
    developer.log('Route: ${route?.settings.name}');
    developer.log('Route arguments: ${route?.settings.arguments}');

    // Try to get quiz ID from route arguments first, then from widget
    final String? routeQuizId = route?.settings.arguments as String?;
    _currentQuizId = routeQuizId ?? widget.quizId;

    developer.log('Final quizId used: $_currentQuizId');

    // Validate quiz ID
    if (_currentQuizId == null || _currentQuizId!.isEmpty) {
      developer.log('ERROR: No quiz ID available');
      _showErrorAndGoBack('No Quiz ID provided');
      return;
    }

    // Initialize the quiz
    _initializeQuiz();
  }

  void _initializeQuiz() {
    if (_currentQuizId != null && _currentQuizId!.isNotEmpty) {
      developer.log('Initializing quiz with ID: $_currentQuizId');

      // Start loading questions
      context.read<QuizCubit>().getQuestions(_currentQuizId!);

      // Start timer
      _startTimer();
    }
  }

  void _showErrorAndGoBack(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate back after showing error
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 60; // Reset timer

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _submitQuiz(context.read<QuizCubit>().state);
        }
      });
    });
  }

  int _mapAnswerToIndex(String correctKey, Map<String, String> options) {
    if (correctKey.isEmpty || options.isEmpty) {
      developer.log('Warning: Empty correctKey or options');
      return 0;
    }

    // Convert correct key to uppercase since Firestore has "A", "B", "C", "D"
    final upperCorrectKey = correctKey.toUpperCase();
    final keys = options.keys.toList();

    // Sort keys to ensure consistent order (A, B, C, D)
    keys.sort();

    final index = keys.indexOf(upperCorrectKey);
    developer.log(
      'Mapping answer: $correctKey ($upperCorrectKey) -> index: $index',
    );
    developer.log('Available keys: $keys');

    return index >= 0 ? index : 0; // Return 0 if not found instead of -1
  }

  // Add this method to your QuizPage class
// Add this method to your QuizPage class (using simplified ReviewAnswersCubit)
void _submitQuiz(QuizState state) {
  developer.log('Submitting quiz, current state: ${state.runtimeType}');
  
  if (state is! LoadedState || !mounted) {
    developer.log('Cannot submit quiz - invalid state or not mounted');
    return;
  }
  
  // Cancel timer first to prevent further state changes
  _timer?.cancel();
  
  int correctCount = 0;
  int wrongCount = 0;
  final questions = state.questions;
  
  // Lists to store review questions (you'll need to create ReviewQuestion class)
  List<ReviewQuestion> correctAnswers = [];
  List<ReviewQuestion> wrongAnswers = [];
  
  developer.log('Total questions: ${questions.length}');
  developer.log('User answers: $userAnswers');
  
  try {
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final correctAnswerIndex = _mapAnswerToIndex(
        question.correctAnswer,
        question.options,
      );
      
      // Create ReviewQuestion for this question
      final reviewQuestion = ReviewQuestion(
        
        userAnswer: userAnswers.containsKey(i) ? question.options.values.toList()[userAnswers[i]!] : 'Unanswered',
        id: i.toString(),
        questionText: question.text,
        options: question.options.values.toList(),
        correctAnswerIndex: correctAnswerIndex,
        userAnswerIndex: userAnswers[i] ?? -1, // -1 for unanswered
        explanation: '',
        correctAnswer: '', // Add explanation if available
      );
      
      if (userAnswers.containsKey(i)) {
        if (userAnswers[i] == correctAnswerIndex) {
          correctCount++;
          correctAnswers.add(reviewQuestion);
          developer.log('Question $i: CORRECT');
        } else {
          wrongCount++;
          wrongAnswers.add(reviewQuestion);
          developer.log('Question $i: WRONG (user: ${userAnswers[i]}, correct: $correctAnswerIndex)');
        }
      } else {
        wrongCount++;
        wrongAnswers.add(reviewQuestion);
        developer.log('Question $i: UNANSWERED');
      }
    }

    developer.log('Final results: $correctCount correct, $wrongCount wrong');
    
    double accuracy = questions.isNotEmpty ? correctCount / questions.length : 0.0;
    
    // Set the review data in the globally available cubit
    try {
      context.read<ReviewAnswersCubit>().setQuizResults(correctAnswers, wrongAnswers);
      developer.log('Successfully set quiz results in ReviewAnswersCubit');
    } catch (e) {
      developer.log('Error setting review results: $e');
    }
    
    QuizResult result = QuizResult(
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      wrongAnswers: wrongCount,
      accuracy: accuracy,
      detailedResults: [
        {'correct': correctAnswers.length},
        {'wrong': wrongAnswers.length},
      ],
    );

    // Navigate to result page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(quizResult: result),
      ),
      (route) => route.isFirst,
    );
  } catch (e) {
    developer.log('Error submitting quiz: $e');
    _showErrorAndGoBack('Error calculating results');
  }
}  void _retryLoading() {
    if (_currentQuizId != null && _currentQuizId!.isNotEmpty) {
      developer.log('Manual retry requested');
      setState(() {
        // Reset state
        currentQuestionIndex = 0;
        selectedAnswerIndex = null;
        showResult = false;
        userAnswers.clear();
      });

      // Restart timer and reload questions
      _startTimer();
      context.read<QuizCubit>().getQuestions(_currentQuizId!);
    }
  }

  @override
  void dispose() {
    developer.log('QuizPage disposing...');
    _timer?.cancel();

    // Don't manually dispose the cubit - let the BlocProvider handle it
    // The cubit will be automatically disposed when the BlocProvider is disposed

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorApp.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Quiz ID: ${_currentQuizId ?? "Unknown"}',
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: ColorApp.backgroundColor,
        foregroundColor: ColorApp.whiteColor,
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          developer.log('BlocListener: State changed to ${state.runtimeType}');

          if (state is ErrorState) {
            developer.log('ERROR STATE: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ERROR: ${state.error}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: _retryLoading,
                ),
              ),
            );
          } else if (state is LoadedState) {
            developer.log(
              'LOADED STATE: ${state.questions.length} questions loaded',
            );

            // Reset timer when questions are loaded
            if (mounted) {
              setState(() {
                _timeLeft = 60;
              });
              _startTimer();
            }
          }
        },
        builder: (context, state) {
          developer.log(
            'BlocBuilder: Building with state ${state.runtimeType}',
          );

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
                    onPressed: _retryLoading,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.primaryButtonColor,
                    ),
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
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
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
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _retryLoading,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorApp.primaryButtonColor,
                          ),
                          child: const Text('Retry'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            developer.log('Go Back button pressed');
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Go Back'),
                        ),
                      ],
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
                  Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: ColorApp.greyColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Questions Available',
                    style: TextStyle(color: ColorApp.whiteColor, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quiz ID: $_currentQuizId',
                    style: const TextStyle(color: Colors.yellow, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _retryLoading,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.primaryButtonColor,
                        ),
                        child: const Text('Retry'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          // Main quiz UI
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Progress and info
                  LinearProgressIndicator(
                    backgroundColor: ColorApp.textFieldBackgroundColor
                        .withOpacity(0.5),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(16),
                    value:
                        (currentQuestionIndex + 1).toDouble() /
                        state.questions.length,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorApp.whiteColor,
                    ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _timeLeft <= 10
                                  ? Colors.red.withOpacity(0.2)
                                  : ColorApp.primaryButtonColor.withOpacity(
                                    0.2,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_timeLeft}s',
                          style: TextStyle(
                            color:
                                _timeLeft <= 10
                                    ? Colors.red
                                    : ColorApp.whiteColor,
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
                      question:
                          state.questions[currentQuestionIndex].text.toString(),
                      numOfQuestion: "${currentQuestionIndex + 1}",
                      selectedAnswers:
                          state.questions[currentQuestionIndex].options.values
                              .toList(),
                      correctAnswerIndex: _mapAnswerToIndex(
                        state.questions[currentQuestionIndex].correctAnswer,
                        state.questions[currentQuestionIndex].options,
                      ),
                      onAnswerSelected: (int index) {
                        developer.log(
                          'Answer selected: $index for question $currentQuestionIndex',
                        );
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

                  // Navigation buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed:
                            currentQuestionIndex > 0
                                ? () {
                                  setState(() {
                                    currentQuestionIndex--;
                                    selectedAnswerIndex =
                                        userAnswers[currentQuestionIndex];
                                    showResult = selectedAnswerIndex != null;
                                  });
                                }
                                : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                                states.contains(MaterialState.disabled)
                                    ? ColorApp.primaryButtonColor.withOpacity(
                                      0.5,
                                    )
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
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            currentQuestionIndex < state.questions.length - 1
                                ? () {
                                  setState(() {
                                    currentQuestionIndex++;
                                    selectedAnswerIndex =
                                        userAnswers[currentQuestionIndex];
                                    showResult = selectedAnswerIndex != null;
                                  });
                                }
                                : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                                states.contains(MaterialState.disabled)
                                    ? ColorApp.primaryButtonColor.withOpacity(
                                      0.5,
                                    )
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

                  // Submit button
                  if (currentQuestionIndex == state.questions.length - 1) ...[
                    SizedBox(height: height / 25.25),
                    SizedBox(
                      width: width / 1.15,
                      height: height / 16.9,
                      child: ElevatedButton(
                        onPressed: () => _submitQuiz(state),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            ColorApp.primaryButtonColor,
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
