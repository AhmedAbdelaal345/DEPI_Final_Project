import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';
import '../widgets/onboard_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  final List<OnboardPageModel> pages = [
    OnboardPageModel(
      title: 'Welcome to QUIZY',
      desc: 'Test, and track your progress any time, any where',
      imageAsset: 'assets/images/onboard1.png',
    ),
    OnboardPageModel(
      title: 'Students:',
      desc: 'Enter a code, take your quiz, and check your results instantly',
      imageAsset: 'assets/images/onboard2.png',
    ),
    OnboardPageModel(
      title: 'Teachers',
      desc: 'Create quizzes, auto-grade answers, and track student progress',
      imageAsset: 'assets/images/onboard3.png',
    ),
    OnboardPageModel(
      title: 'Choose your role and start now!',
      desc: '',
      imageAsset: 'assets/images/onboard4.png',
      isLast: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0F1722),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _current = index),
                itemBuilder: (context, index) {
                  final p = pages[index];
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      SizedBox(
                        height: media.height * 0.45,
                        child: Center(
                          child: Image.asset(
                            p.imageAsset,
                            fit: BoxFit.contain,
                            width: media.width * 0.6,
                          ),
                        ),
                      ),
                      const Spacer(),
                      OnboardCard(
                        page: p,
                        currentIndex: _current,
                        totalPages: pages.length,
                        onNext: () {
                          if (_current < pages.length - 1) {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          }
                        },
                        onPrev: () {
                          if (_current > 0) {
                            _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
