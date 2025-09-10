import 'package:flutter/material.dart';

class AuthNavigationText extends StatelessWidget {
  final String normalText;
  final String clickableText;
  final VoidCallback onTap;

  const AuthNavigationText({
    super.key,
    required this.normalText,
    required this.clickableText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          normalText,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            clickableText,
            style: const TextStyle(
              color: Color(0xFF2196F3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
