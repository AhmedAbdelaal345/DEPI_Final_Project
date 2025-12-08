// features/Teacher/screens/home_teacher.dart
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/screens/create_new_quiz.dart';
import 'package:depi_final_project/features/Teacher/screens/performance_report.dart';
import 'package:depi_final_project/features/Teacher/screens/recent_quizzes.dart';
import 'package:depi_final_project/features/home/presentation/widgets/title_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class Hometeacher extends StatefulWidget {
  final Function(String)? onTeacherNameLoaded;
  final String? initialTeacherName;

  const Hometeacher({super.key, this.onTeacherNameLoaded, this.initialTeacherName});

  @override
  State<Hometeacher> createState() => _HometeacherState();
}

class _HometeacherState extends State<Hometeacher> {
  String? name;

  @override
  void initState() {
    super.initState();
    // Use initial name if provided
    name = widget.initialTeacherName;

    final credential = FirebaseAuth.instance.currentUser;
    if (credential != null) {
      context.read<CreateQuizCubit>().getquizzes(credential.uid);
      // Load the name from Firebase and update
      _loadTeacherName(credential.uid);
    }
  }

  Future<void> _loadTeacherName(String uid) async {
    final loadedName = await context.read<CreateQuizCubit>().getname(uid);
    if (mounted) {
      setState(() {
        name = loadedName ?? FirebaseAuth.instance.currentUser?.displayName ?? "Teacher";
      });
      // Notify the parent widget
      if (widget.onTeacherNameLoaded != null) {
        widget.onTeacherNameLoaded!(name!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final credential = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleBar(title: l10n.home),
                SizedBox(height: screenHeight * 0.06),
                Text(
                  l10n.welcomeBack(name ?? "Teacher"),
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                GestureDetector(
                  onTap: () async {
                    final cubit = context.read<CreateQuizCubit>();
                    final user = FirebaseAuth.instance.currentUser;
                    final teacherId = user?.uid ?? '';

                    if (credential != null) {
                      final subject = await cubit.getsubject(credential.uid) ?? "unknow";
                      final quizid = await cubit.getSixRandomNumbers();
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: Createnewquiz(
                              teacherId: teacherId,
                              subject: subject,
                              quizId: quizid,
                              uid: credential.uid,
                              teacherName: name ?? "Unknown",
                            ),
                          ),
                        ),
                      );
                      if (result == true && mounted) {
                        await cubit.getquizzes(credential.uid);
                        // Refresh the teacher name in case it changed
                        await _loadTeacherName(credential.uid);
                      }
                    }
                  },
                  child: container(context, 0.15, 0.9, l10n.createNewQuiz),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<CreateQuizCubit>();
                        if (credential != null) {
                          await cubit.getquizzes(credential.uid);
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: Recentquizzes(),
                              ),
                            ),
                          );
                        }
                      },
                      child: container(context, .2, .4, l10n.recentQuizzes),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<CreateQuizCubit>();
                        if (credential != null) {
                          await cubit.getquizzes(credential.uid);
                          final title = await cubit.gettitle(credential.uid);
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: PerformanceReportScreen(
                                  uid: credential.uid,
                                  quizTitles: title,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: container(context, .2, .4, l10n.performanceReport),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget container(
    BuildContext context,
    double heightFactor,
    double widthFactor,
    String txt,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * heightFactor,
      width: screenWidth * widthFactor,
      decoration: BoxDecoration(
        color: AppColors.tealWithOpacity,
        borderRadius: AppBorderRadius.mediumBorderRadius,
        border: Border.all(
          color: AppColors.primaryTeal,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
    );
  }
}