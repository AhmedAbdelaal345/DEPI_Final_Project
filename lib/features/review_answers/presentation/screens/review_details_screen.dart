import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/color_app.dart';
import '../../domain/entities/review_question.dart';
import '../cubit/review_answers_cubit.dart';
import '../cubit/review_answers_state.dart';
import '../widgets/answer_option.dart';
import '../widgets/app_drawer.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/question_container.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final bool fetchWrongAnswers;
  const ReviewDetailsScreen({super.key, required this.fetchWrongAnswers});
static const id = "/reviewdetailsscreen";
  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.fetchWrongAnswers) {
      context.read<ReviewAnswersCubit>().fetchWrongAnswers();
    } else {
      context.read<ReviewAnswersCubit>().fetchCorrectAnswers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorApp.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorApp.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      // ADDED THE DRAWER HERE
      endDrawer: const AppDrawer(),
      body: BlocBuilder<ReviewAnswersCubit, ReviewAnswersState>(
        builder: (context, state) {
          if (state is ReviewAnswersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewAnswersError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ReviewAnswersLoaded) {
            if (state.questions.isEmpty) {
              return const Center(
                child: Text(
                  'No questions to show.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final ReviewQuestion currentQuestion =
                state.questions[_currentIndex];

            return Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.065, // left
                screenHeight * 0.05, // top
                screenWidth * 0.065, // right
                screenHeight * 0.03, // bottom
              ),
              child: Column(
                children: [
                  QuestionContainer(
                    questionText: currentQuestion.questionText,
                    id: currentQuestion.id,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ...currentQuestion.options.map((option) {
                    return AnswerOption(
                      optionText: option,
                      question: currentQuestion,
                    );
                  }).toList(),
                  SizedBox(height: screenHeight * 0.18),
                  NavigationButtons(
                    canGoBack: _currentIndex > 0,
                    canGoForward: _currentIndex < state.questions.length - 1,
                    onPrevious: () {
                      setState(() {
                        _currentIndex--;
                      });
                    },
                    onNext: () {
                      setState(() {
                        _currentIndex++;
                      });
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
