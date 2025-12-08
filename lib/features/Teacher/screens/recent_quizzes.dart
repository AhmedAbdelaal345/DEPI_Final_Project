import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/features/Teacher/screens/view_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class Recentquizzes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      endDrawer: drawer(context),
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            l10n.recentQuizzes.replaceAll('\n', ' '),
            style: GoogleFonts.irishGrover(
              fontSize: AppFontSizes.xxl,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
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
                return GestureDetector(
                  child: container(
                    index,
                    context,
                    screenHeight * .00015,
                    screenWidth * .00009,
                    quiz[AppConstants.title],
                    quiz[AppConstants.createdAt],
                    quiz,
                    quizzesid,
                  ),
                );
              },
            );
          } else if (state is GetQuizError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
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
        height: screenHeight * heightFactor,
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(bottom: screenHeight * .04),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewQuizScreen(
                        title: quiz["title"],
                        duration: quiz["duration"],
                        questions: quiz["questions"],
                        createdAt: formattedDate,
                        quizzesId: quiz["quizid"] ?? "",
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.preview_outlined,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.secondaryBackground,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryTeal,
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.08,
                  width: screenHeight * 0.08,
                  child: Image.asset(AppConstants.brainLogo),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  l10n.appName,
                  style: TextStyle(
                    color: AppColors.secondaryTeal,
                    fontSize: screenWidth * 0.085,
                    fontFamily: "DMSerifDisplay",
                  ),
                ),
              ],
            ),
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WrapperTeacherPage()),
            ),
            context,
            Icon(Icons.home_outlined, color: AppColors.secondaryTeal),
            l10n.home,
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 1),
              ),
            ),
            context,
            Icon(Icons.person_outlined, color: AppColors.secondaryTeal),
            l10n.profile,
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 2),
              ),
            ),
            context,
            Icon(Icons.list, color: AppColors.secondaryTeal),
            l10n.myQuizzes,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryTeal,
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.settings, color: AppColors.secondaryTeal),
              title: Text(
                l10n.setting,
                style: TextStyle(
                  color: AppColors.secondaryTeal,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WrapperTeacherPage(index: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listtitle(
    Function callback,
    BuildContext context,
    Icon icon,
    String txt,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryTeal,
            width: screenHeight * 0.001,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        leading: icon,
        title: Text(
          txt,
          style: TextStyle(
            color: AppColors.secondaryTeal,
            fontSize: screenWidth * 0.06,
          ),
        ),
        onTap: () => callback(),
      ),
    );
  }
}
