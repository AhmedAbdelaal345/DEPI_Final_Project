import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'quiz_history_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 2; 

  final List<Widget> _screens = const [
    HomeScreen(), 
    Center(
        child: Text("Profile",
            style: TextStyle(color: Colors.white, fontSize: 22))),
    QuizHistoryScreen(), // study
    Center(
        child: Text("Settings",
            style: TextStyle(color: Colors.white, fontSize: 22))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF1A1C2B),
        color: const Color(0xFF2C2F48),
        buttonBackgroundColor: const Color(0xFF5AC7C7),
        height: 60,
        index: 2,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.check_circle, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
