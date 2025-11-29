// features/home/presentation/Screens/home_screen.dart
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/Quiz/presentation/Screens/before_quiz_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/app_constants.dart';
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
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    final code = _quizController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterQuizCode), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => BeforeQuizScreen(quizId: code)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join quiz: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
              Padding(padding: EdgeInsets.symmetric(horizontal: sx(context, 20)), child: MotivationalText(text: l10n.phase)),
              SizedBox(height: sy(context, 48)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: JoinQuizForm(controller: _quizController, isProcessing: _isProcessing, onJoin: () => _joinQuiz(context)),
                ),
              ),
              SizedBox(height: sy(context, 18)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextButton(
                  onPressed: () {},
                  child: const Text("What's this?", style: TextStyle(color: Colors.white70)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
