// features/Onboarding/widgets/onboarding_illustrations.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/onboard_page_model.dart';

class OnboardingIllustrations extends StatelessWidget {
  final int currentIndex;
  final List<OnboardPageModel> pages;
  const OnboardingIllustrations({
    super.key,
    required this.currentIndex,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final int index = currentIndex.clamp(0, pages.length - 1);
    final String image = pages[index].imageAsset;

    // Small static rotation offset based on index (no overlap animation)
    final double baseAngle = (index % 6) * 0.04; // ~0 -> 0.2 rad

    return Center(
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.35,
        decoration: BoxDecoration(
          // gradient: const RadialGradient(
          //   center: Alignment.center,
          //   radius: 0.8,
          //   colors: [
          //     Color(0xFF1A2B47),
          //     Color(0xFF0A1628),
          //   ],
          // ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Container(
            width: 287,
            height: 317.48,
            // decoration: BoxDecoration(
            //   color: const Color(0xFF2B8B87).withOpacity(0.10),
            //   borderRadius: BorderRadius.circular(110),
            //   border: Border.all(
            //     color: const Color(0xFF2B8B87).withOpacity(0.28),
            //     width: 2,
            //   ),
            // ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              layoutBuilder:
                  (currentChild, previousChildren) => Stack(
                    alignment: Alignment.center,
                    children: [if (currentChild != null) currentChild],
                  ),
              transitionBuilder: (child, animation) {
                final bool isIncoming = (child.key == ValueKey(index));
                if (!isIncoming) return const SizedBox.shrink();
                return RotationTransition(
                  turns: Tween<double>(
                    begin: 0.97,
                    end: 1.0,
                  ).animate(animation),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.98,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Transform.translate(
                key: ValueKey(index),
                offset: Offset(0, -index * 10),
                child: SvgPicture.asset(image, height: 317.48, width: 287),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
