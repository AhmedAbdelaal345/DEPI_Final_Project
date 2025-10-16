import 'package:depi_final_project/features/Onboarding/widgets/last_page_buttons.dart';
import 'package:flutter/material.dart';

class OnboardingNavigation extends StatelessWidget {
  final int currentIndex; // index within the indicators range
  final int totalIndicators; // number of indicator dots
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final bool isLast;

  const OnboardingNavigation({
    super.key,
    required this.currentIndex,
    required this.totalIndicators,
    required this.onNext,
    required this.onPrev,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirst = currentIndex <= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button
        IgnorePointer(
          ignoring: isFirst,
          child: AnimatedOpacity(
            opacity: isFirst ? 0.4 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: _roundButton(icon: Icons.chevron_left, onTap: onPrev),
          ),
        ),

        // Page indicators
        Row(
          children: List.generate(totalIndicators, (i) {
            final bool active = currentIndex == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 24 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.white30,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),

        // Next button
        _roundButton(
          icon: Icons.chevron_right,
          onTap: () {
            if (!isLast) {
              onNext();
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SelectUserPage.id,
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _roundButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Color(0xff000B27), size: 40),
    );
  }
}
