import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class ViewQuizScreen extends StatefulWidget {
  final String title;
  final String createdAt;
  final String duration;
  final String quizzesId;
  final List<Map<String, dynamic>> questions;
  const ViewQuizScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.questions,
    required this.createdAt,
    required this.quizzesId,
  });

  @override
  State<ViewQuizScreen> createState() => _ViewQuizScreenState();
}

class _ViewQuizScreenState extends State<ViewQuizScreen> {
  int currentPage = 0;
  final PageController pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      endDrawer: drawer(context),
      appBar: AppBar(
        title: Text(
          'View Quiz',
          style: GoogleFonts.irishGrover(
            textStyle: TextStyle(
              fontSize: screenWidth * 0.07,
              color: AppColors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.secondaryBackground,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * .02),
              container(
                context,
                screenHeight * .00008,
                screenWidth * .00009,
                widget.title,
                widget.createdAt,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.53,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: widget.questions.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return containerQuestion(
                        context,
                        index,
                        widget.questions[index]["question"]?.toString() ??
                            "No Question",
                        List<String>.from(
                          widget.questions[index]["option"] ?? [],
                        ),
                        widget.questions[index]["answer"]?.toString() ?? "",
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        l10n.durationInMinutes,
                        style: TextStyle(
                          fontSize: AppFontSizes.lg,
                          color: AppColors.white,
                        ),
                      ),
                      subtitle: TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
                          hintText: widget.duration,
                          hintStyle: TextStyle(
                            fontSize: AppFontSizes.lg,
                            color: AppColors.white,
                          ),
                          filled: true,
                          fillColor: AppColors.primaryBackground,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppBorderRadius.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: AppColors.tealWithOpacity,
                              width: AppDimensions.borderWidth,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppBorderRadius.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: AppColors.lightTeal,
                              width: AppDimensions.borderWidth,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        l10n.quizCode,
                        style: TextStyle(
                          fontSize: AppFontSizes.lg,
                          color: AppColors.white,
                        ),
                      ),
                      subtitle: Container(
                        height: AppDimensions.buttonHeight,
                        padding: EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: AppBorderRadius.mediumBorderRadius,
                        ),
                        child: Text(
                          widget.quizzesId,
                          style: TextStyle(
                            fontSize: AppFontSizes.lg,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                      backgroundColor:
                          currentPage == 0
                              ? AppColors.grey.withOpacity(0.6)
                              : AppColors.primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.largeBorderRadius,
                      ),
                    ),
                    onPressed:
                        currentPage > 0
                            ? () {
                              pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                currentPage--;
                              });
                            }
                            : null,
                    child: Text(
                      "Prev",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * .035),
                  TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                      backgroundColor:
                          currentPage == widget.questions.length - 1
                              ? AppColors.grey.withOpacity(0.6)
                              : AppColors.primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.largeBorderRadius,
                      ),
                    ),
                    onPressed:
                        currentPage < widget.questions.length - 1
                            ? () {
                              pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                currentPage++;
                              });
                            }
                            : null,
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget container(
    BuildContext context,
    double heightFactor,
    double widthFactor,
    String txt1,
    String createdAt,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
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
              Text(
                txt1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              Text(
                "Created on $createdAt",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.03,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerField(BuildContext context, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: AppColors.primaryTeal,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.white,
          fontSize: screenWidth * 0.038,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget containerQuestion(
    BuildContext context,
    int index,
    String questionText,
    List<String> options,
    String correctAnswer,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            border: Border.all(
              color: AppColors.primaryTeal,
              width: AppDimensions.borderWidth,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.questionNumber(index + 1),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                containerField(context, "Q${index + 1}: $questionText"),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  l10n.enterOptionsAndSelectCorrect,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  children: List.generate(options.length, (i) {
                    bool isCorrect = options[i] == correctAnswer;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.008,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: screenWidth * 0.06,
                            height: screenWidth * 0.06,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryTeal,
                                width: AppDimensions.borderWidth,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: screenWidth * 0.03,
                                height: screenWidth * 0.03,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isCorrect
                                          ? AppColors.primaryTeal
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Text(
                              options[i],
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
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
