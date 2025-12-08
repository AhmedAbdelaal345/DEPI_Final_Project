import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
import 'package:depi_final_project/features/Teacher/screens/quizcreatesuccesfully.dart';
import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class Createnewquiz extends StatefulWidget {
  final String teacherId;
  final String subject;
  final String quizId;
  final String uid;
  final String teacherName;
  const Createnewquiz({
    required this.quizId,
    required this.subject,
    required this.teacherId,
    required this.uid,
    required this.teacherName,
    super.key,
  });

  @override
  State<Createnewquiz> createState() => _CreatenewquizState();
}

class _CreatenewquizState extends State<Createnewquiz> {
  final TextEditingController durationController = TextEditingController();
  final TextEditingController quizTitle = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    durationController.dispose();
    quizTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cubit = context.read<CreateQuizCubit>();
    final l10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cubit.state.questions.isEmpty) {
        cubit.addqeustion();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      resizeToAvoidBottomInset: true,
      endDrawer: drawer(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            l10n.createNewQuiz,
            style: GoogleFonts.irishGrover(
              fontSize: AppFontSizes.xxl,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: key,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.01,
                ),
                child: containerField(context, quizTitle, l10n.enterQuizTitle),
              ),
              Expanded(
                child: BlocBuilder<CreateQuizCubit, CreateQuizState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          // List of questions
                          ...List.generate(state.questions.length, (index) {
                            return containerQuestion(
                              context,
                              index,
                              state.questions[index],
                              state.options[index],
                              state.answers[index],
                              cubit,
                            );
                          }),
                          SizedBox(height: screenHeight * 0.02),
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
                                    controller: durationController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.thisFieldRequired;
                                      }
                                      // Check if the value is a valid integer
                                      final intValue = int.tryParse(value.trim());
                                      if (intValue == null) {
                                        return l10n.pleaseEnterValidInteger;
                                      }
                                      // Optional: Check if the value is positive
                                      if (intValue <= 0) {
                                        return l10n.durationMustBePositive;
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: AppColors.white),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: AppFontSizes.lg,
                                        color: AppColors.white54,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.lg),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 26,
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius: AppBorderRadius.mediumBorderRadius,
                                    ),
                                    child: Text(
                                      widget.quizId,
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
                          SizedBox(height: AppSpacing.lg),
                          BlocConsumer<CreateQuizCubit, CreateQuizState>(
                            listener: (context, state) {
                              if (state is CreateQuizSaved) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => QuizCreateSuccessful(
                                          quizId: widget.quizId,
                                        ),
                                  ),
                                );
                                durationController.clear();
                                quizTitle.clear();
                              } else if (state is CreateQuizError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              return TextButton(
                                style: TextButton.styleFrom(
                                  fixedSize: Size(
                                    screenWidth * 0.9,
                                    screenHeight * 0.06,
                                  ),
                                  backgroundColor: AppColors.primaryTeal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppBorderRadius.largeBorderRadius,
                                  ),
                                ),
                                onPressed:
                                    state is CreateQuizLoading
                                        ? null
                                        : () {
                                          if (key.currentState!.validate()) {
                                            cubit.savedQuiz(
                                              widget.quizId,
                                              durationController.text.trim(),
                                              cubit.state.questions.length,
                                              widget.subject,
                                              widget.teacherId,
                                              quizTitle.text.trim(),
                                              widget.uid,
                                              widget.teacherName,
                                            );
                                          }
                                        },
                                child:
                                    state is CreateQuizLoading
                                        ? CircularProgressIndicator(
                                          color: AppColors.primaryTeal,
                                        )
                                        : Text(
                                          l10n.create,
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: screenWidth * 0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //================ Helper Widgets ==================
  Widget containerField(
    BuildContext context,
    TextEditingController controller,
    String hint,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: screenHeight * 0.08,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: AppColors.primaryTeal,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return l10n.thisFieldRequired;
          }
          return null;
        },
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: screenWidth * 0.038,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.white54,
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.038,
          ),
        ),
      ),
    );
  }

  Widget containerQuestion(
    BuildContext context,
    int index,
    TextEditingController questionController,
    List<TextEditingController> optionControllers,
    TextEditingController answerController,
    CreateQuizCubit cubit,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;
    int selectedIndex = -1;

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
                  TextButton(
                    onPressed: () => cubit.addqeustion(),
                    child: Text(
                      l10n.addQuestion,
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              containerField(context, questionController, l10n.enterQuestion),
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
                children: List.generate(optionControllers.length, (i) {
                  bool isSelected = i == selectedIndex;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.008,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = i;
                              answerController.text = optionControllers[i].text;
                            });
                          },
                          child: Container(
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
                                      isSelected
                                          ? AppColors.primaryTeal
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: TextFormField(
                            controller: optionControllers[i],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.thisFieldRequired;
                              }
                              return null;
                            },
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: screenWidth * 0.035,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: AppColors.white54),
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
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 0),
              ),
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
