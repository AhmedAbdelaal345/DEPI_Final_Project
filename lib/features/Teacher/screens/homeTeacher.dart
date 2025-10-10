import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/screens/PerformanceReport.dart';
import 'package:depi_final_project/features/Teacher/screens/createNewQuiz.dart';
import 'package:depi_final_project/features/Teacher/screens/recentQuizzes.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/title_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class Hometeacher extends StatefulWidget {
  const Hometeacher({super.key});

  @override
  State<Hometeacher> createState() => _HometeacherState();
}

class _HometeacherState extends State<Hometeacher> {
  @override
  void initState() {
    super.initState();
    final credintial = FirebaseAuth.instance.currentUser;
    if (credintial != null) {
      context.read<CreateQuizCubit>().getquizzes(credintial.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final credintial = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff000920),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 TitleBar(title: l10n.home),
                SizedBox(height: screenHeight * 0.06),
                FutureBuilder<String?>(
                  future: context.read<CreateQuizCubit>().getname(credintial!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...");
                    }
                    if (snapshot.hasError) {
                      return const Text("Error loading name");
                    }
                    final name = snapshot.data ?? "Unknown";
                    return Text(
                      l10n.welcomeBack(name),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * 0.06,
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.06),
                GestureDetector(
                  onTap: () async {
                    final cubit = context.read<CreateQuizCubit>();
                    final teacherId = await cubit.getname(credintial!.uid) ?? "unknow";
                    final subject = await cubit.getsubject(credintial.uid) ?? "unknow";
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
                            uid: credintial.uid,
                          ),
                        ),
                      ),
                    );
                    if (result == true && mounted) {
                      await cubit.getquizzes(credintial.uid);
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
                        await cubit.getquizzes(credintial!.uid);
                        
                        if (mounted) {
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
                      child: container(context, .2, .4, "Recent\n Quizzes"),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<CreateQuizCubit>();
                        await cubit.getquizzes(credintial!.uid);
                        final title = await cubit.gettitle(credintial.uid);      
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: PerformanceReportScreen(
                                  uid: credintial.uid,
                                  quizTitles: title,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: container(context, .2, .4, "Performance Report"),
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
  Widget container(BuildContext context, double heightFactor, double widthFactor, String txt) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * heightFactor,
      width: screenWidth * widthFactor,
      decoration: BoxDecoration(
        color: Color(0xff1877F2).withOpacity(0.11),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xff4FB3B7),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xffFFFFFF),
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
    );
  }
}