// core/widgets/profile_components.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  final Widget avatar;
  final String displayName;
  final String email;
  final double topSpacing;

  const ProfileHeader({super.key, required this.avatar, required this.displayName, required this.email, this.topSpacing = 60});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topSpacing),
        avatar,
        const SizedBox(height: 10),
        Text(
          displayName,
          style: GoogleFonts.judson(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 32),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double width;

  const StatCard({super.key, required this.icon, required this.label, required this.value, required this.width});

  @override
  Widget build(BuildContext context) {
    final widthRatio = width;
    return Container(
      width: 317 * widthRatio,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFF000B27), border: Border.all(color: const Color(0xFF5AC7C7)), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28 * widthRatio),
          SizedBox(width: 16 * widthRatio),
          Expanded(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 16 * widthRatio, fontWeight: FontWeight.w500))),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 24 * widthRatio, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
