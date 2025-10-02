import 'dart:async';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/features/questions/presentation/widget/page_component.dart';
import 'package:depi_final_project/features/review_answers/domain/entities/review_question.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_cubit.dart';
import 'package:depi_final_project/features/review_answers/presentation/widgets/navigation_buttons.dart';
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
  int? _timeLeft; // هنا هنخزن الوقت بالثواني
  String? _currentQuizId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchTimeLeft();
  }

  /// 🕒 دالة تجيب الـ duration من Firestore (بالدقايق) وتحوله ثواني
  Future<void> _fetchTimeLeft() async {
    final doc =
        await FirebaseFirestore.instance
            .collection(AppConstants.quizzesCollection)
            .doc(widget.quizId)
            .get();

    final minutes = doc.data()?["duration"];
    if (minutes != null) {
      setState(() {
        _timeLeft = minutes * 60; // minutes → seconds
      });
    } else {
      setState(() {
        _timeLeft = 60; // default
      });
    }
  }

  int? get timeLeft => _timeLeft;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;
    _isInitialized = true;

    final route = ModalRoute.of(context);
    final String? routeQuizId = route?.settings.arguments as String?;
    _currentQuizId = routeQuizId ?? widget.quizId;

    if (_currentQuizId == null || _currentQuizId!.isEmpty) {
      _showErrorAndGoBack('No Quiz ID provided');
      return;
    }

    _initializeQuiz();
  }

  void _initializeQuiz() {
    if (_currentQuizId != null && _currentQuizId!.isNotEmpty) {
      context.read<QuizCubit>().getQuestions(_currentQuizId!);
      _startTimer();
    }
  }

  void _retryLoading() {
    if (_currentQuizId != null && _currentQuizId!.isNotEmpty) {
      developer.log('Manual retry requested');
      setState(() {
        currentQuestionIndex = 0;
        selectedAnswerIndex = null;
        showResult = false;
        userAnswers.clear();
      });
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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  /// 🕒 هنا التايمر بيعد تنازلي من الـ duration
  void _startTimer() {
    _timer?.cancel();

    if (_timeLeft == null || _timeLeft! <= 0) {
      _timeLeft = 120; // default 1 دقيقة
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_timeLeft! > 0) {
          _timeLeft = _timeLeft! - 1;
        } else {
          timer.cancel();
          _submitQuiz(context.read<QuizCubit>().state);
        }
      });
    });
  }

int _mapAnswerToIndex(String correctAnswer, List<String> options) {
  if (correctAnswer.isEmpty || options.isEmpty) {
    developer.log('Warning: Empty correctAnswer or options');
    return 0;
  }
  
  final index = options.indexWhere(
    (option) => option.trim().toLowerCase() == correctAnswer.trim().toLowerCase()
  );
  
  return index >= 0 ? index : 0;
}
  void _submitQuiz(QuizState state) {
    if (state is! LoadedState || !mounted) {
      return;
    }
    _timer?.cancel();
    int correctCount = 0;
    int wrongCount = 0;
    final questions = state.questions;
    List<ReviewQuestion> correctAnswers = [];
    List<ReviewQuestion> wrongAnswers = [];
    try {
      for (int i = 0; i < questions.length; i++) {
        final question = questions[i];
        final correctAnswerIndex = _mapAnswerToIndex(
          question.correctAnswer,
          question.options,
        );
        final reviewQuestion = ReviewQuestion(
          userAnswer:
              userAnswers.containsKey(i)
                  ? question.options.toList()[userAnswers[i]!]
                  : 'Unanswered',
          id: i.toString(),
          questionText: question.text,
          options: question.options.toList(),
          correctAnswerIndex: correctAnswerIndex,
          userAnswerIndex: userAnswers[i] ?? -1, // -1 for unanswered
          explanation: '',
          correctAnswer: '', // Add explanation if available
        );
        if (userAnswers.containsKey(i)) {
          if (userAnswers[i] == correctAnswerIndex) {
            correctCount++;
            correctAnswers.add(reviewQuestion);
          } else {
            wrongCount++;
            wrongAnswers.add(reviewQuestion);
          }
        } else {
          wrongCount++;
          wrongAnswers.add(reviewQuestion);
        }
      }
      double accuracy =
          questions.isNotEmpty ? correctCount / questions.length : 0.0;
      try {
        context.read<ReviewAnswersCubit>().setQuizResults(
          correctAnswers,
          wrongAnswers,
        );
      } catch (e) {
        print(e);
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(quizResult: result)),
        (route) => route.isFirst,
      );
    } catch (e) {
      _showErrorAndGoBack('Error calculating results');
    }
  }

  /// 🕒 لتحويل الثواني لدقايق:ثواني
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
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
          if (state is ErrorState) {
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
            if (mounted) {
              // هنا مش هتحتاج تجيب duration من questions
              // لو القيمة اتجابت قبل كده من Firestore، خليها زي ما هي
              if (_timeLeft == null) {
                _timeLeft = 60; // default لو لأي سبب ما اتجابتش
              }
              _startTimer();
            }
          }
        },
        builder: (context, state) {
          // UI الأساسي بتاع الكويز (مش هنغير فيه غير مكان عرض الوقت)
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! LoadedState || state.questions.isEmpty) {
            return const Center(child: Text("No Questions Available"));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                              _timeLeft != null && _timeLeft! <= 10
                                  ? Colors.red.withOpacity(0.2)
                                  : ColorApp.primaryButtonColor.withOpacity(
                                    0.2,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _timeLeft != null ? _formatTime(_timeLeft!) : "00:00",
                          style: TextStyle(
                            color:
                                _timeLeft != null && _timeLeft! <= 10
                                    ? Colors.red
                                    : ColorApp.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height / 12.6), // Question Expanded
                  Expanded(
                    child: PageComponent(
                      question:
                          state.questions[currentQuestionIndex].text.toString(),
                      numOfQuestion: "${currentQuestionIndex + 1}",
                      selectedAnswers:
                          state.questions[currentQuestionIndex].options                              .toList(),
                      correctAnswerIndex: _mapAnswerToIndex(
                        state.questions[currentQuestionIndex].correctAnswer,
                        state.questions[currentQuestionIndex].options,
                      ),
                      onAnswerSelected: (int index) {
                        setState(() {
                          selectedAnswerIndex = index;
                          showResult = false;
                          userAnswers[currentQuestionIndex] = index;
                        });
                      },
                      selectedAnswerIndex: selectedAnswerIndex,
                      showResult: showResult,
                    ),
                  ), // Navigation buttons
                  NavigationButtons(
                    canGoBack: currentQuestionIndex > 0,
                    canGoForward:
                        currentQuestionIndex < state.questions.length - 1,
                    onPrevious: () {
                      setState(() {
                        currentQuestionIndex--;
                        //here we return the selected answer index to default when we go back
                         selectedAnswerIndex = userAnswers[currentQuestionIndex];
                      });
                    },
                    onNext: () {
                      setState(() {
                        currentQuestionIndex++;
                        //here we return the selected answer index to default when we go forward
                        selectedAnswerIndex = userAnswers[currentQuestionIndex];
                      });
                    },
                  ), // Submit button
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 
