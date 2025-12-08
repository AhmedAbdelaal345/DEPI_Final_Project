// features/home/presentation/Screens/home_screen.dart
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/Quiz/presentation/Screens/before_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import '../widgets/home_components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _quizController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _quizController.dispose();
    super.dispose();
  }

  Future<void> _joinQuiz(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    final code = _quizController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseEnterQuizCode),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BeforeQuizScreen(quizId: code),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join quiz: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(Title: l10n.home),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: MotivationalText(text: l10n.phase),
              ),
              SizedBox(height: screenHeight * 0.06),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: JoinQuizForm(
                    controller: _quizController,
                    isProcessing: _isProcessing,
                    onJoin: () => _joinQuiz(context),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "What's this?",
                    style: TextStyle(color: AppColors.white54),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
