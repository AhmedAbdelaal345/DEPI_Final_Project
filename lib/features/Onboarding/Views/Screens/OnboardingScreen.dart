import 'package:depi_final_project/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../Widgets/fluid_card.dart';
import '../Widgets/fluid_carousel.dart';

// Quiz App Onboarding Screens
class Showcase extends StatefulWidget {
  const Showcase({super.key, required this.title});

  final String title;

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidCarousel(
        children: <Widget>[
          FluidCard(
            color: 'Yellow',
            altColor: Color(0xFF904E93),
            title: "Test Your Knowledge",
            subtitle:
                "Challenge yourself with thousands of questions across multiple categories and difficulty levels.",
          ),
          AbsorbPointer(
        absorbing: false,
        child: FluidCard(
          color: 'Blue',
          altColor: Color(0xFFFFB138),
          title: "Learn & Compete",
          subtitle:
          "Improve your skills, compete with friends, and track your progress with detailed analytics.",
          button: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF904E93), Color(0xFFFFB138)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.rocket_launch,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Start Your Journey',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

        ],
      ),
    );
  }
}
