import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/onboard_page_model.dart';

class OnboardingTexts extends StatelessWidget {
  final int currentIndex;
  final List<OnboardPageModel> pages;
  const OnboardingTexts({
    super.key,
    required this.currentIndex,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final int index = currentIndex.clamp(0, pages.length - 1);
    final page = pages[index];

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            page.title,
            style: GoogleFonts.judson(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (page.desc.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              page.desc,
              style: GoogleFonts.judson(
                fontSize: 24,
                color: Color(0xff000B27),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
