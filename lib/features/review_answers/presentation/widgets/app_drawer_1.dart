import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_app.dart';


class AppDrawer1 extends StatelessWidget {
  final Function(int) onItemTapped;
  const AppDrawer1({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth*0.6,
      backgroundColor: const Color(0xff061438), // لون الخلفية للقائمة
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff061438), // يمكنك تغييره إذا أردت لونًا مختلفًا للهيدر
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                  child: Image.asset(
                    'assets/images/brain_logo.png',
                    height: screenHeight*0.1,
                  ),
                ),
                Text(
                  'QUIZLY',
                  style: GoogleFonts.irishGrover(
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth*0.06,
                    color: ColorApp.splashTextColor,
                  ),
                ),
              ],
            ),
          ),




          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(
            icon: Icons.home_outlined,
            text: 'Home',
            onTap: () {
              Navigator.pop(context); // أغلق القائمة أولاً
              onItemTapped(0); // استدعي الدالة بالـ index الصحيح
            },
          ),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(
            icon: Icons.person_outline,
            text: 'Profile',
            onTap: () {
              Navigator.pop(context);
              onItemTapped(1);
            },
          ),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(
            icon: Icons.history_edu_outlined,
            text: 'History',
            onTap: () {
              Navigator.pop(context);
              onItemTapped(2);
            },
          ),
          const Divider(color: Color(0xff4FB3B7)),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Setting',
            onTap: () {
              Navigator.pop(context);
              onItemTapped(3);
            },
          ),
        ],
      ),
    );
  }

  // ودجت مساعد لبناء كل عنصر في القائمة لتجنب تكرار الكود
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      minLeadingWidth: 0,
      leading: Icon(icon, color: Color(0xff4FB3B7), size: 24,),
      title: Text(text, style: GoogleFonts.judson(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Color(0xff4FB3B7),
      ),),
      onTap: onTap,
    );
  }
}