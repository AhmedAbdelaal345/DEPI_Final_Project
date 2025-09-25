import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';
import 'onboarding_texts.dart';
import 'onboarding_navigation.dart';
import 'last_page_buttons.dart';

class OnboardingContentSection extends StatelessWidget {
  final int currentIndex;
  final List<OnboardPageModel> pages;
  final int indicatorIndex;
  final int indicatorsCount;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const OnboardingContentSection({
    super.key,
    required this.currentIndex,
    required this.pages,
    required this.indicatorIndex,
    required this.indicatorsCount,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Texts (current only)
          OnboardingTexts(currentIndex: currentIndex, pages: pages),
          const Spacer(),
          // Dots and nav OR last buttons
          if (pages[currentIndex].isLast)
            const LastPageButtons()
          else
            OnboardingNavigation(
              currentIndex: indicatorIndex,
              totalIndicators: indicatorsCount,
              onNext: onNext,
              onPrev: onPrev,
            ),
        ],
      ),
    );
  }
}
