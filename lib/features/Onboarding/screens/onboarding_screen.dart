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


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardPageModel> pages = OnboardingConstants.getPages(context);

    final int indicatorIndex =
    (_current <= pages.length - 3) ? _current : (pages.length - 3);
    final int indicatorsCount = (pages.length - 1).clamp(0, pages.length);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1426),
      body: SafeArea(
        child: Stack(
          children: [
            OnboardingPageController(
              pageController: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _current = index),
            ),
            Column(
              children: [
                OnboardingIllustrationSection(
                  currentIndex: _current,
                  pages: pages,
                ),
                Expanded(
                  flex: 4,
                  child: OnboardingBackground(
                    child: OnboardingContentSection(
                      currentIndex: _current,
                      pages: pages,
                      indicatorIndex: indicatorIndex,
                      indicatorsCount: indicatorsCount,
                      onNext: () => _nextPage(pages.length),
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


  void _nextPage(int pageLength) {
    if (_current < pageLength - 1) {
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