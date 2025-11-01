import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constants.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key, required this.title, this.showLogo = true});

  final String title;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final h = sy(context, 64);
    return SizedBox(
      height: h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: GoogleFonts.irishGrover(
                  fontSize: sx(context, 32),
                  fontWeight: FontWeight.w400,
                  color: ColorApp.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(width: sx(context, 100)),
        ],
      ),
    );
  }
}
