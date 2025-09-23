import 'package:flutter/material.dart';

class OnboardingPageController extends StatelessWidget {
  final PageController pageController;
  final int itemCount;
  final Function(int) onPageChanged;

  const OnboardingPageController({
    super.key,
    required this.pageController,
    required this.itemCount,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) => const SizedBox.shrink(),
    );
  }
}
