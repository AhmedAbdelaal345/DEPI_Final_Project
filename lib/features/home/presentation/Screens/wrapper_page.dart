// features/home/presentation/Screens/wrapper_page.dart
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:depi_final_project/features/profile/presentation/screens/profile_screen_with_firebase.dart' ;
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:depi_final_project/core/widgets/app_drawer.dart';
import 'quiz_history_screen.dart';

class WrapperPage extends StatefulWidget {
  final int initialIndex;
  const WrapperPage({super.key, this.initialIndex = 0, this.isTeacher});
  final bool? isTeacher;
  static const String id = '/wrapper-page';   
  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  int _currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Map<int, Widget> _cache = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<WidgetBuilder> _builders = [
    (ctx) => const HomeScreen(),
    (ctx) => const ProfileScreenWithFirebase(),
    (ctx) => const QuizHistoryScreen(),
    (ctx) => const SettingScreen(),
  ];

  Widget _screenForIndex(BuildContext ctx, int index) {
    return _cache[index] ??= _builders[index](ctx);
  }

  final List<IconData> _icons = const [
    Icons.home,
    Icons.person,
    Icons.history,
    Icons.settings,
  ];

  // page titles (unused variable removed to avoid lint)

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
      drawer: AppDrawer(
        onItemTapped: (index) {

          _onPageChanged(index); // غير الصفحة


          final navigationState = _bottomNavigationKey.currentState;
          navigationState?.setPage(index);
        },
      ),

      // Add SafeArea to prevent overflow issues
  body: SafeArea(child: _screenForIndex(context, _currentIndex)),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: const Color(0xFF000920),
        color: const Color(0xFF47969E),
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
