import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';
import '../constants/onboarding_constants.dart';
import '../widgets/onboarding_illustration_section.dart';
import '../widgets/onboarding_content_section.dart';
import '../widgets/onboarding_background.dart';
import '../widgets/onboarding_page_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  List<OnboardPageModel> get pages => OnboardingConstants.pages;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _indicatorIndex =>
      (_current <= pages.length - 2) ? _current : (pages.length - 2);

  int get _indicatorsCount => (pages.length - 1).clamp(0, pages.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1426),
      body: SafeArea(
        child: Stack(
          children: [
            // Background PageView to drive controller and gestures
            OnboardingPageController(
              pageController: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _current = index),
            ),

            // Foreground fixed layout
            Column(
              children: [
                // Top illustration area
                OnboardingIllustrationSection(
                  currentIndex: _current,
                  pages: pages,
                ),

                // Bottom content area
                Expanded(
                  flex: 4,
                  child: OnboardingBackground(
                    child: OnboardingContentSection(
                      currentIndex: _current,
                      pages: pages,
                      indicatorIndex: _indicatorIndex,
                      indicatorsCount: _indicatorsCount,
                      onNext: _nextPage,
                      onPrev: _previousPage,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_current < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _previousPage() {
    if (_current > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }
}
