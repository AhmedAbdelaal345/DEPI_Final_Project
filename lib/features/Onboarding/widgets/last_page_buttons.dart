import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/features/auth/presentation/screens/register_details_screen.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class SelectUserPage extends StatelessWidget {
  static const String id = 'select_user_page';

  const SelectUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF2B8B87),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.062,
          vertical: screenHeight * 0.059,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                'assets/images/onbording4.svg',
                width: screenWidth * 0.77,
                height: screenHeight * 0.355,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: screenHeight * 0.019),
            SizedBox(
              width: double.infinity,
              child: Text(
                l10n.onboarding4Title,
                style: GoogleFonts.judson(
                  fontSize: screenWidth * 0.072,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.019),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.057,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RegisterDetailsScreen(isTeacher: false),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2B8B87),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.041),
                  ),
                ),
                child: Text(
                  l10n.imAStudent,
                  style: GoogleFonts.judson(
                    fontSize: screenWidth * 0.051,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.014),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.057,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RegisterDetailsScreen(isTeacher: true),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white,
                    width: screenWidth * 0.005,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.041),
                  ),
                ),
                child: Text(
                  l10n.imATeacher,
                  style: GoogleFonts.judson(
                    fontSize: screenWidth * 0.051,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
