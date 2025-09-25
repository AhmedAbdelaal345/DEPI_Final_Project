import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base color with noise texture
          SvgPicture.asset(
            'assets/images/noise.svg',
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Color(0xFF6BB6B8),
              BlendMode.multiply,
            ),
          ),
          // Content overlay
          child,
        ],
      ),
    );
  }
}
