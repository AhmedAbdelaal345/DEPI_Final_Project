import 'package:depi_final_project/features/Teacher/screens/homeTeacher.dart';
import 'package:depi_final_project/features/profile/presentation/screens/profile_screen_with_firebase.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizCreateSuccessful extends StatelessWidget {
  final String quizId;
  const QuizCreateSuccessful({required this.quizId, super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawer: drawer(context),
      backgroundColor: const Color(0xff000921),
      appBar: AppBar(backgroundColor: const Color(0xff000921), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.13),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: Container(
                      width: screenWidth * 0.55,
                      height: screenWidth * 0.55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff07FF11),
                          width: screenWidth * 0.015,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: const Color(0xff07FF11),
                          size: screenWidth * 0.29,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    "Quiz Created",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    "Anyone who has this code can join and take the quiz.",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.06,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff455A64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quizId,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: quizId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quiz code copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.06,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Hometeacher()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4FB3B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawer(context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Color(0xff061438),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff061438),
              border: Border(bottom: BorderSide(color: Color(0xff4FB3B7))),
            ),
            child: Row(
              children: [
                Image.asset("assets/images/brain_logo.png"),
                Text(
                  "QUIZLY",
                  style: TextStyle(
                    color: Color(0xff62DDE1),
                    fontSize: screenWidth * .085,
                    fontFamily: "DMSerifDisplay",
                  ),
                ),
              ],
            ),
          ),
          listtitle(
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Hometeacher()),
              );
            },
            context,
            Icon(
              Icons.home_outlined,
              size: screenWidth * .1,
              color: Color(0xff62DDE1),
            ),
            "Home",
          ),
          listtitle(
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreenWithFirebase(),
                ),
              );
            },
            context,
            Icon(
              Icons.person_outlined,
              size: screenWidth * .1,
              color: Color(0xff62DDE1),
            ),
            "Profile",
          ),
          listtitle(
            () {},
            context,
            Icon(Icons.list, size: screenWidth * .1, color: Color(0xff62DDE1)),
            "My Quizzes",
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: screenWidth * .1,
              color: Color(0xff62DDE1),
            ),
            title: Text(
              "Setting",
              style: TextStyle(
                color: Color(0xff62DDE1),
                fontSize: screenWidth * .06,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listtitle(Function callback, context, Icon icon, String txt) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff4FB3B7))),
      ),
      child: ListTile(
        leading: icon,
        title: Text(
          txt,
          style: TextStyle(
            color: Color(0xff62DDE1),
            fontSize: screenWidth * .06,
          ),
        ),
        onTap: () {
          callback();
        },
      ),
    );
  }
}
