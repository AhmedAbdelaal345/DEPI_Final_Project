// features/home/presentation/widgets/home_components.dart
import 'package:flutter/material.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:depi_final_project/core/widgets/shared_components.dart';
import 'package:depi_final_project/features/home/presentation/widgets/input_field.dart';
import 'package:depi_final_project/features/home/presentation/widgets/primary_button.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationalText extends StatelessWidget {
  final String text;
  const MotivationalText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.judson(
        color: AppColors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class JoinQuizForm extends StatelessWidget {
  final TextEditingController controller;
  final bool isProcessing;
  final VoidCallback onJoin;

  const JoinQuizForm({super.key, required this.controller, required this.isProcessing, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputField(key: const ValueKey('quiz_code_input'), controller: controller, hint: l10n.enterQuizCode),
        SizedBox(height: sy(context, 16)),
        isProcessing ? const Center(child: LoadingIndicator(size: 28)) : PrimaryButton(label: l10n.join, onTap: onJoin),
      ],
    );
  }
}

class HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorView(message: message, onRetry: onRetry, retryLabel: 'Retry');
  }
}
