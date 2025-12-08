// features/profile/presentation/widgets/stat_card.dart
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';

import 'package:iconify_flutter/iconify_flutter.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const StatCard({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5AC7C7)),
      ),
      child: Row(
        children: [
          Iconify(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

