import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

class InputField extends StatelessWidget {
  const InputField({super.key, required this.hint,required this.controller});
final TextEditingController controller ;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(sx(context, 12));
    return Container(
      height: sy(context, 52),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: r),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
      child: TextField(
        controller:controller ,
        cursorColor: AppColors.bgDarkText,
        style: GoogleFonts.poppins(
          color: AppColors.bgDarkText,
          fontSize: sx(context, 14),
        ),
        decoration: InputDecoration(
          
          isCollapsed: true,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: AppColors.hint.withOpacity(0.7),
            fontSize: sx(context, 14),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
