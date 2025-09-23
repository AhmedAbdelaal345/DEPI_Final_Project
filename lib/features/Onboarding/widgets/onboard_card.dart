import 'package:depi_final_project/features/auth/presentation/screens/register_details_screen.dart';
import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';

class OnboardCard extends StatelessWidget {
  final OnboardPageModel page;
  final int currentIndex;
  final int totalPages;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;

  const OnboardCard({
    super.key,
    required this.page,
    required this.currentIndex,
    required this.totalPages,
    this.onNext,
    this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF2B8B87),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (page.title.isNotEmpty)
            Text(
              page.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          if (page.desc.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              page.desc,
              style: const TextStyle(
                fontSize: 13,
                height: 1.25,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 14),
          page.isLast
              ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the login screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterDetailsScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2B8B87),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('student'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterDetailsScreen(
                              isTeacher: true,
                            )),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('teacher'),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onPrev,
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                    Row(
                      children: List.generate(
                        totalPages,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == i ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == i
                                ? Colors.white
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onNext,
                      icon:
                          const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
