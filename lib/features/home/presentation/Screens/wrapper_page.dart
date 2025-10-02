import 'package:depi_final_project/features/home/presentation/Screens/profile_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import '../../../review_answers/presentation/widgets/app_drawer_1.dart';
import 'quiz_history_screen.dart';


class WrapperPage extends StatefulWidget {
  final int initialIndex;
  const WrapperPage({super.key, this.initialIndex = 0});
static const String id = '/wrapper-page';
  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  int _currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  List<Widget> get _screens => [
    const HomeScreen(),
    ProfileScreen(),
    const QuizHistoryScreen(),
    SettingScreen(),
  ];

  final List<IconData> _icons = const [
    Icons.home,
    Icons.person,
    Icons.history,
    Icons.settings,
  ];

  final List<String> _titles = const [
    'Home',
    'Profile',
    'Quiz History',
    'Settings',
  ];

  // دالة لتغيير الصفحة وتحديث الحالة
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      drawer: AppDrawer1(
        onItemTapped: (index) {
          // عندما يتم الضغط على عنصر في القائمة
          _onPageChanged(index); // غير الصفحة

          // هذا السطر مهم لتحديث شكل الأيقونة في شريط التنقل السفلي
          final navigationState = _bottomNavigationKey.currentState;
          navigationState?.setPage(index);
        },
      ),

      // Add SafeArea to prevent overflow issues
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: const Color(0xFF1A1C2B),
        color: const Color(0xFF2C2F48),
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
