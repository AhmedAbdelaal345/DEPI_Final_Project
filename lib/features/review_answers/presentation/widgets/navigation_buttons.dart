// lib/features/review_answers/presentation/widgets/navigation_buttons.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/color_app.dart';

class NavigationButtons extends StatelessWidget {
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: canGoBack ? onPrevious : null,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: canGoBack ? const Color(0xff4FB3B7) : const Color(0xff4FB3B7).withOpacity(0.4),
            ),
            child: Icon(
              Icons.fast_rewind,
              color: ColorApp.backgroundColor,
              size: 35,
            ),
          ),
        ),
        GestureDetector(
          onTap: canGoForward ? onNext : null,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: canGoForward ? const Color(0xff4FB3B7) : const Color(0xff4FB3B7).withOpacity(0.4),
            ),
            child: Icon(
              Icons.fast_forward,
              color: ColorApp.backgroundColor,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }
}