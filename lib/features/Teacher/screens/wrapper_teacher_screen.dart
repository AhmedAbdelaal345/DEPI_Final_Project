// features/Teacher/wrapper_teacher_screen.dart
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/screens/home_teacher.dart';
import 'package:depi_final_project/features/Teacher/screens/myquizzes.dart';
import 'package:depi_final_project/features/Teacher/screens/teacher_profile.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WrapperTeacherPage extends StatefulWidget {
  final int? index;
  const WrapperTeacherPage({super.key, this.index = 0});
  static const String id = '/wrapper-page';
  @override
  State<WrapperTeacherPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperTeacherPage> {
  late int _currentIndex;
  String? _teacherName;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<IconData> _icons = const [
    Icons.home,
    Icons.person,
    Icons.list,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
    // Load teacher name when the wrapper page initializes
    _loadTeacherName();
  }

  Future<void> _loadTeacherName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = await context.read<CreateQuizCubit>().getname(user.uid);
      if (mounted) {
        setState(() {
          _teacherName = name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            Hometeacher(
              initialTeacherName: _teacherName,
              onTeacherNameLoaded: (name) {
                if (mounted && _teacherName != name) {
                  setState(() {
                    _teacherName = name;
                  });
                }
              }
            ),
            TeacherProfileScreen(teacherName: _teacherName),
            Myquizzes(),
            SettingScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor:  Colors.transparent,
        color: AppColors.primaryTeal,
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
                color: isSelected ? Colors.white : const Color(0xB3FFFFFF),
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