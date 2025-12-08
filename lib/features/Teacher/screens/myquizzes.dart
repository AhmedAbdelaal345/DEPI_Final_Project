import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class Myquizzes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            l10n.myQuizzes,
            style: GoogleFonts.irishGrover(
              fontSize: AppFontSizes.xxl,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: Image(
          image: AssetImage(AppConstants.brainLogo),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CreateQuizCubit, CreateQuizState>(
        builder: (context, state) {
          if (state is GetQuiz) {
            final quizzes = state.quizList;
            final quizzesid = state.quizzesId;
            if (quizzes.isEmpty) {
              return Center(
                child: Text(
                  l10n.noQuestionsAvailable,
                  style: TextStyle(color: AppColors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return container(
                  index,
                  context,
                  screenHeight * .00015,
                  screenWidth * .00009,
                  quiz[AppConstants.title],
                  quiz[AppConstants.quizId] ?? "",
                  quiz[AppConstants.teacherId] ?? "",
                  quiz[AppConstants.createdAt],
                  quiz,
                  quizzesid,
                );
              },
            );
          } else if (state is GetQuizError) {
            return Center(
              child: Text(
                "Error ${state.message}",
                style: TextStyle(color: AppColors.error),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryTeal,
            ),
          );
        },
      ),
    );
  }

  Widget container(
    int index,
    BuildContext context,
    double heightFactor,
    double widthFactor,
    String txt,
    String quizid,
    String teacherid,
    dynamic createdAt,
    dynamic quiz,
    List<dynamic> quizzesId,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String formattedDate = "";
    if (createdAt is Timestamp) {
      DateTime date = createdAt.toDate();
      formattedDate = "${date.day}/${date.month}/${date.year}";
    } else if (createdAt is DateTime) {
      formattedDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    } else {
      formattedDate = createdAt?.toString() ?? "Unknown";
    }
    return Center(
      child: Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(top: screenHeight * .02),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.mediumBorderRadius,
          border: Border.all(
            color: AppColors.primaryTeal,
            width: AppDimensions.borderWidth,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    txt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    "code $quizid",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.039,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    "Created on $formattedDate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  final cubit = await context
                      .read<CreateQuizCubit>()
                      .removeQuiz(quizid, teacherid);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Quiz "$txt" deleted successfully'),
                        backgroundColor: AppColors.success,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
