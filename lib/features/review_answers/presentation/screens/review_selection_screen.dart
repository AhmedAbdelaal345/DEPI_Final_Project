import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/mock_review_repository_impl.dart';
import '../cubit/review_answers_cubit.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_review_button.dart';
import 'review_details_screen.dart';

class ReviewSelectionScreen extends StatelessWidget {
  const ReviewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => ReviewAnswersCubit(MockReviewRepositoryImpl()),
      child: Builder(
        builder: (context) {
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
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    );
                  },
                ),
              ],
            ),
            endDrawer: const AppDrawer(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
              child: Column(
                children: [
                  Text(
                    'Review your Answers',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.judson(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Text(
                    'Which Answers you would review first',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.judson(
                      fontSize: screenWidth * 0.052,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Image.asset(
                    'assets/images/review_answer.png',
                    height: screenHeight * 0.22,
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  CustomReviewButton(
                    text: 'Wrong Answers',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: BlocProvider.of<ReviewAnswersCubit>(
                                  context,
                                ),
                                child: const ReviewDetailsScreen(
                                  fetchWrongAnswers: true,
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomReviewButton(
                    text: 'Correct Answers',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: BlocProvider.of<ReviewAnswersCubit>(
                                  context,
                                ),
                                child: const ReviewDetailsScreen(
                                  fetchWrongAnswers: false,
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
