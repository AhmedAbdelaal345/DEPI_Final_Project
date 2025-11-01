import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.Title,
  });

  final String Title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          Title,
          style: GoogleFonts.irishGrover(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: const Image(
        image: AssetImage('assets/images/brain_logo.png'),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
