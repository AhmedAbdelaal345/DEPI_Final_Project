import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/Quiz/presentation/Screens/before_quiz_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_constants.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final TextEditingController quiz = TextEditingController();
    // final TextEditingController teacherId = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(Title: l10n.home),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Motivational Message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sx(context, 20)),
                child: Text(
                  l10n.phase,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sy(context, 18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: sy(context, 48)),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // InputField(
                      //   hint: l10n.enterTeacherCode,
                      //   controller: teacherId,
                      // ),
                      SizedBox(height: sy(context, 16)),
                      InputField(hint: l10n.enterQuizCode, controller: quiz),
                    ],
                  ),
                ),
              ),
              SizedBox(height: sy(context, 18)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PrimaryButton(
                  label: l10n.join,
                  onTap: () {
                    if (quiz.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BeforeQuizScreen(
                                quizId: quiz.text,
                                
                              ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.pleaseEnterQuizCode),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
