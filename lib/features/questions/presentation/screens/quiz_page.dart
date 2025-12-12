import 'dart:async';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';

import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/features/questions/presentation/widget/page_component.dart';
import 'package:depi_final_project/features/review_answers/presentation/model/review_question.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_cubit.dart';
import 'package:depi_final_project/features/review_answers/presentation/widgets/navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/result_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_protector/screen_protector.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, this.quizId, this.teacherId, this.name});

  static const String id = '/quiz-page';
  final String? quizId;
  final String? teacherId;
  final String? name;

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
  String? _teacherId;
  String? _quizName;
  bool _isInitialized = false;
  bool _isSubmitting = false;
  Future<void> _configureWindow() async {
    try {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageOn(); // Also prevents screen recording on Android
      Fluttertoast.showToast(
        msg: "Screen secured from screenshots",
        backgroundColor: AppColors.error,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      developer.log('Error enabling screen protection: $e');
    }
  }

  Future<void> _disableScreenProtection() async {
    try {
      await ScreenProtector.preventScreenshotOff();
      await ScreenProtector.protectDataLeakageOff();
    } catch (e) {
      developer.log('Error disabling screen protection: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    //we make it here to prevent user take screenshot from questions page
    _configureWindow();
  }

  Future<void> _fetchTimeLeft() async {
    if (_teacherId == null || _currentQuizId == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection(AppConstants.quizzesCollection)
            .doc(_currentQuizId)
            .get();

    final data = doc.data();
    int minutes = 1;
    if (data != null && data[AppConstants.duration] is int) {
      minutes = data[AppConstants.duration];
    }

    setState(() {
      _timeLeft = minutes * 60;
    });

    _startTimer(_timeLeft!);
  }

  int? get timeLeft => _timeLeft;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;
    _isInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is List && args.length >= 3) {
      _currentQuizId = args[0] as String?;
      _teacherId = args[1] as String?;
      final durationMinutes = int.tryParse(args[2].toString());
      if (args.length >= 4) {
        _quizName = args[3] as String?;
      }
      _timeLeft = (durationMinutes ?? 1) * 60; // نحولها لثواني
      _startTimer(_timeLeft!);
    } else {
      _showErrorAndGoBack('Missing quiz or teacher ID');
      return;
    }

    _initializeQuiz();
  }

  void _initializeQuiz() {
    if (_currentQuizId != null && _currentQuizId!.isNotEmpty) {
      context.read<QuizCubit>().getQuestions(_currentQuizId!);
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
    });
  }

  /// 🕒 هنا التايمر بيعد تنازلي من الـ duration
  void _startTimer(int duration) {
    _timer?.cancel();

    if (_timeLeft == null || _timeLeft! <= 0) {
      _timeLeft = duration; // default 1 دقيقة
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
      (option) =>
          option.trim().toLowerCase() == correctAnswer.trim().toLowerCase(),
    );

    return index >= 0 ? index : 0;
  }

  void _submitQuiz(QuizState state) {
    if (_isSubmitting) return;
    _isSubmitting = true;

    if (state is! LoadedState || !mounted) {
      _isSubmitting = false;
      return;
    }

    _timer?.cancel();
    int correctCount = 0;
    int wrongCount = 0;
    final questions = state.questions;
    developer.log("Abdelaal: ${questions.toString()}");
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
          studentAnswer:
              userAnswers.containsKey(i)
                  ? question.options.toList()[userAnswers[i]!]
                  : 'Unanswered',
          id: i.toString(),
          questionText: question.text,
          options: question.options.toList(),
          correctAnswerIndex: correctAnswerIndex,
          userAnswerIndex: userAnswers[i] ?? -1,
          explanation: '',
          correctAnswer: '',
          teacherId: _teacherId ?? '',
          isCorrect: selectedAnswerIndex == correctAnswerIndex,
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

      final accuracy =
          questions.isNotEmpty ? correctCount / questions.length : 0.0;

      if (mounted) {
        context.read<ReviewAnswersCubit>().setQuizResults(
          correctAnswers,
          wrongAnswers,
        );
      }

      final List<Map<String, dynamic>> questionsWithAnswers = [];
      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        final studentAns =
            userAnswers.containsKey(i)
                ? q.options.toList()[userAnswers[i]!]
                : 'Unanswered';
        questionsWithAnswers.add({
          'question': q.text,
          'options': q.options.toList(),
          'answer': q.correctAnswer,
          'studentAnswer': studentAns,
        });
      }

      final status =
          (questions.isNotEmpty && (correctCount / questions.length) >= 0.5)
              ? 'Pass'
              : 'Fail';

      if (mounted) {
        context.read<ResultCubit>().saveStudentQuizResult(
          studentId: FirebaseAuth.instance.currentUser!.uid,
          quizId:
              _currentQuizId ??
              ModalRoute.of(context)!.settings.arguments.toString(),
          questionsWithAnswers: questionsWithAnswers,
          questions: questions,
          status: status,
        );
      }

      final result = QuizResult(
        totalQuestions: questions.length,
        correctAnswers: correctCount,
        wrongAnswers: wrongCount,
        accuracy: accuracy,
        quizId:
            (_currentQuizId ??
                ModalRoute.of(context)!.settings.arguments.toString()),
        detailedResults: questionsWithAnswers,
        questions: questions,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(quizResult: result)),
        (route) => route.isFirst,
      );
    } catch (e, st) {
      developer.log('Error in _submitQuiz: $e', stackTrace: st);
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      // backgroundColor: ColorApp.backgroundColor,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _quizName ?? l10n.quizId(_currentQuizId ?? "Unknown"),
            style: GoogleFonts.irishGrover(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
              _startTimer(_timeLeft ?? 60);
            }
          }
        },
        builder: (context, state) {
          // UI الأساسي بتاع الكويز (مش هنغير فيه غير مكان عرض الوقت)
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! LoadedState || state.questions.isEmpty) {
            return Center(child: Text(l10n.noQuestionsAvailable));
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
                        style: TextStyle(
                          color: ColorApp.whiteColor,
                          fontSize: 18,
                        ),
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
                                  ? Colors.red.withValues(alpha: 0.2)
                                  : ColorApp.primaryButtonColor.withValues(
                                    alpha: 0.2,
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
                          state.questions[currentQuestionIndex].options
                              .toList(),
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
                          backgroundColor: WidgetStatePropertyAll(
                            ColorApp.primaryButtonColor,
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.submitQuiz,
                          style: TextStyle(
                            color: AppColors.hintText,
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

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _disableScreenProtection();
    super.dispose();
  }
}
