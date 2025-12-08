import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

class CurvedBottomNav extends StatelessWidget {
  const CurvedBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final h = sy(context, 62);
    final r = BorderRadius.circular(sx(context, 22));
    return Padding(
      padding: EdgeInsets.fromLTRB(
        sx(context, 12),
        0,
        sx(context, 12),
        sy(context, 10),
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Container(
          height: h,
          color: AppColors.teal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavIcon(icon: Icons.home_rounded, active: currentIndex == 0),
              _NavIcon(icon: Icons.person_outline, active: currentIndex == 1),
              _NavIcon(icon: Icons.mail_outline, active: currentIndex == 2),
              _NavIcon(
                icon: Icons.settings_outlined,
                active: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, this.active = false});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final size = sx(context, 26);
    return Container(
      width: sx(context, 54),
      height: sx(context, 54),
      alignment: Alignment.center,
      decoration:
          active
              ? const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tealHighlight,
              )
              : null,
      child: Icon(icon, color: AppColors.bgDarkText, size: size),
    );
  }
}
