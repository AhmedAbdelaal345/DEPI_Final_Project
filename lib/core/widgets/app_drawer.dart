// core/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:depi_final_project/core/constants/color_app.dart';

typedef DrawerTapCallback = void Function(int index);

class AppDrawer extends StatelessWidget {
  final DrawerTapCallback? onItemTapped;
  const AppDrawer({super.key, this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth * 0.6,
      backgroundColor: const Color(0xff061438),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xff061438)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                  child: Image.asset('assets/images/brain_logo.png', height: screenWidth * 0.12),
                ),
                const SizedBox(width: 8),
                Text(l10n.appName, style: GoogleFonts.irishGrover(color: ColorApp.splashTextColor, fontSize: screenWidth * 0.06)),
              ],
            ),
          ),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(context, Icons.home_outlined, l10n.home, 0),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(context, Icons.person_outline, l10n.profile, 1),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(context, Icons.history_edu_outlined, l10n.quizHistory, 2),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(context, Icons.settings_outlined, l10n.settings, 3),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String text, int index) {
    return ListTile(
      minLeadingWidth: 0,
      leading: Icon(icon, color: const Color(0xff4FB3B7), size: 24),
      title: Text(text, style: GoogleFonts.judson(fontSize: 20, fontWeight: FontWeight.w400, color: const Color(0xff4FB3B7))),
      onTap: () {
        Navigator.pop(context);
        if (onItemTapped != null) onItemTapped!(index);
      },
    );
  }
}
