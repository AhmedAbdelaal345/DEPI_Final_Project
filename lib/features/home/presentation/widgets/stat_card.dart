// lib/features/home/presentation/widgets/stat_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double widthRatio;
  final double heightRatio;
  final bool isLast;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.widthRatio,
    required this.heightRatio,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 317 * widthRatio,
      height: isLast ? 89 * heightRatio : 82 * heightRatio,
      padding: EdgeInsets.symmetric(
        horizontal: 20 * widthRatio,
        vertical: 16 * heightRatio,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF000B27),
        border: Border.all(
          color: const Color(0xFF5AC7C7),
          width: 1 * widthRatio,
        ),
        borderRadius: BorderRadius.circular(10 * widthRatio),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28 * widthRatio,
          ),
          SizedBox(width: 16 * widthRatio),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.judson(
                color: Colors.white,
                fontSize: 22 * widthRatio,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.judson(
              color: Colors.white,
              fontSize: 24 * widthRatio,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}