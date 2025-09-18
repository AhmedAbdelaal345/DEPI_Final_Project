import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/widgets/app_constants.dart';

class QuizDetailsScreen extends StatelessWidget {
  const QuizDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitleBar(context),
              SizedBox(height: sy(context, 20)),

              // Top info cards (2 up)
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      Icons.list_alt_rounded,
                      'Questions',
                      '25',
                      isIconTop: true,
                    ),
                  ),
                  SizedBox(width: sx(context, 12)),
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      Icons.schedule_rounded,
                      'Time limit',
                      '30 Mins',
                      isIconTop: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sy(context, 12)),

              // Creator full-width card
              _buildInfoCard(
                context,
                Icons.person_rounded,
                'Creator',
                'Mr.Mohamed Ali',
                isIconTop: false,
              ),
              SizedBox(height: sy(context, 14)),

              // Instructions block
              _buildInstructionsCard(context),
              SizedBox(height: sy(context, 24)),

              // Beautiful Journey Start Button
              _buildJourneyStartButton(context),
              SizedBox(height: sy(context, 16)),

              // Back button
              _buildBackButton(context),
              SizedBox(height: sy(context, 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return SizedBox(
      height: sy(context, 64),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: sx(context, 65),
              height: sx(context, 65),
              child: Image.asset(
                'assets/images/brain_logo.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6A5ACD),
                          Color(0xFF00B4D8),
                          Color(0xFFFF7EB3),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: sx(context, 10)),
          Text(
            'Math Basics Quiz',
            style: GoogleFonts.irishGrover(
              fontSize: sx(context, 28),
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    required bool isIconTop,
  }) {
    final r = BorderRadius.circular(sx(context, 12));
    final labelStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 12),
      fontWeight: FontWeight.w600,
    );
    final valueStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, isIconTop ? 18 : 16),
      fontWeight: FontWeight.w700,
    );

    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: r),
      padding: EdgeInsets.symmetric(
        horizontal: sx(context, 16),
        vertical: sy(context, 14),
      ),
      child: isIconTop
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.bgDarkText, size: sx(context, 24)),
                SizedBox(height: sy(context, 6)),
                Text(title, style: labelStyle),
                SizedBox(height: sy(context, 2)),
                Text(value, style: valueStyle),
              ],
            )
          : Row(
              children: [
                Icon(icon, color: AppColors.bgDarkText, size: sx(context, 24)),
                SizedBox(width: sx(context, 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: labelStyle),
                    SizedBox(height: sy(context, 2)),
                    Text(value, style: valueStyle),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildInstructionsCard(BuildContext context) {
    final r = BorderRadius.circular(sx(context, 12));
    final titleStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontWeight: FontWeight.w700,
      fontSize: sx(context, 14),
    );
    final bodyStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 13),
      height: 1.35,
    );

    final bullets = [
      'Ensure you have a stable internet connection.',
      'The quiz will automatically submit when the time runs out.',
      'You cannot pause the quiz once started.',
    ];

    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: r),
      padding: EdgeInsets.fromLTRB(
        sx(context, 16),
        sy(context, 12),
        sx(context, 16),
        sy(context, 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_rounded,
                size: sx(context, 22),
                color: AppColors.bgDarkText,
              ),
              SizedBox(width: sx(context, 8)),
              Text('Instructions', style: titleStyle),
            ],
          ),
          SizedBox(height: sy(context, 8)),
          ...bullets.map(
            (b) => Padding(
              padding: EdgeInsets.only(bottom: sy(context, 6)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: sx(context, 6),
                    height: sx(context, 6),
                    margin: EdgeInsets.only(top: sy(context, 7)),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.bgDarkText,
                    ),
                  ),
                  SizedBox(width: sx(context, 10)),
                  Expanded(child: Text(b, style: bodyStyle)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyStartButton(BuildContext context) {
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
          onTap: () {
            // Start quiz action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Quiz Started! Good luck!'),
                backgroundColor: AppColors.teal,
                duration: const Duration(seconds: 2),
              ),
            );
            // Add your quiz start logic here
          },
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

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      height: sy(context, 52),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.bgDarkText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sx(context, 16)),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Back to Home',
          style: GoogleFonts.judson(
            color: AppColors.bgDarkText,
            fontWeight: FontWeight.w700,
            fontSize: sx(context, 18),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
