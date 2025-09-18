import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/widgets/app_constants.dart';

class QuizJourneyStartButton extends StatelessWidget {
  const QuizJourneyStartButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sy(context, 70),
      margin: EdgeInsets.symmetric(horizontal: sx(context, 8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sx(context, 20)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4FB3B7),
            Color(0xFF84D9D7),
            Color(0xFF4FB3B7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(sx(context, 20)),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: sx(context, 24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rocket_launch_rounded,
                  color: AppColors.bgDarkText,
                  size: sx(context, 28),
                ),
                SizedBox(width: sx(context, 12)),
                Expanded(
                  child: Text(
                    'Click To Start Your Journey',
                    style: GoogleFonts.judson(
                      color: AppColors.bgDarkText,
                      fontWeight: FontWeight.w700,
                      fontSize: sx(context, 18),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.bgDarkText,
                  size: sx(context, 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
