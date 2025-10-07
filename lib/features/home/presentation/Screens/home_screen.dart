import 'package:depi_final_project/core/widgets/custom_app_bar.dart';
import 'package:depi_final_project/features/Quiz/presentation/Screens/quiz_details_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/title_bar.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_constants.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    final TextEditingController quiz = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(
        title: 'Home',
        showBackButton: false,
      ),
      body: SafeArea(

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // input field
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InputField(
                    hint: 'Enter quiz code',
                    controller: quiz,
                  ),
                ),
              ),
              SizedBox(height: sy(context, 18)),

              // join button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PrimaryButton(
                  label: 'Join',
                  onTap: () {
                    if (quiz.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BeforeQuizScreen(
                            quizId: quiz.text, // 👈 مرر الـ quizId هنا
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a quiz code'),
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
