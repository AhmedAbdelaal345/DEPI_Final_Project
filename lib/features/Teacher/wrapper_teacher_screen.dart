import 'package:depi_final_project/features/Teacher/screens/homeTeacher.dart';
import 'package:depi_final_project/features/Teacher/screens/myquizzes.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:depi_final_project/features/profile/presentation/screens/profile_screen_with_firebase.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class WrapperTeacherPage extends StatefulWidget {
  final int?index;
  const WrapperTeacherPage({super.key,this.index=0});
  static const String id = '/wrapper-page';
  @override
  State<WrapperTeacherPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperTeacherPage> {
  late int _currentIndex ;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Widget> get _screens => [
    Hometeacher(),
    ProfileScreenWithFirebase(),
    Myquizzes(),
    SettingScreen(),
  ];

  final List<IconData> _icons = const [
    Icons.home,
    Icons.person,
    Icons.list,
    Icons.settings,
  ];

  final List<String> _titles = const [
    'Home',
    'Profile',
    'Recent Quizzes',
    'Settings',
  ];
    @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: const Color(0xFF1A1C2B),
        color: const Color(0xff4FB3B7),
        buttonBackgroundColor: const Color(0xFF5AC7C7),
        height: 65,
        index: _currentIndex,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items:
            _icons.asMap().entries.map((entry) {
              int index = entry.key;
              IconData icon = entry.value;
              bool isSelected = index == _currentIndex;

              return Icon(
                icon,
                size: isSelected ? 35 : 28,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              );
            }).toList(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
