// core/widgets/custom_app_bar.dart
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar Widget for consistent app bar styling across the app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: GoogleFonts.irishGrover(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: ColorApp.whiteColor,
          ),
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
