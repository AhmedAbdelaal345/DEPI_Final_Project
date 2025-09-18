import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/widgets/app_constants.dart';

class QuizInstructionsCard extends StatelessWidget {
  const QuizInstructionsCard({super.key, required this.instructions});

  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
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
          ...instructions.map(
            (instruction) => Padding(
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
                  Expanded(child: Text(instruction, style: bodyStyle)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
