import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        child: Image.asset(
          iconPath,
          width: screenWidth *0.06,
          height: screenWidth *0.06,
        ),
      ),
    );
  }
}