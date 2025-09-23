import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';
import 'onboarding_illustrations.dart';

class OnboardingIllustrationSection extends StatelessWidget {
  final int currentIndex;
  final List<OnboardPageModel> pages;

  const OnboardingIllustrationSection({
    super.key,
    required this.currentIndex,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Center(
          child: OnboardingIllustrations(
            currentIndex: currentIndex,
            pages: pages,
          ),
        ),
      ),
    );
  }
}
