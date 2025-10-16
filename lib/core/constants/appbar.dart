import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.Title,
  });

  final String Title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Title, style: const TextStyle(color: Colors.white)),
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
