import 'package:depi_final_project/features/Teacher/wrapper_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class QuizCreateSuccessful extends StatelessWidget {
  final String quizId;
  const QuizCreateSuccessful({required this.quizId, super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      endDrawer: drawer(context),
      backgroundColor: const Color(0xff000921),
      appBar: AppBar(backgroundColor: const Color(0xff000921), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
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
                      l10n.quizCreated,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.06,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      l10n.quizCreatedMessage,
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
                          SnackBar(content: Text(l10n.quizCodeCopied)),
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
                    MaterialPageRoute(
                      builder: (_) => const WrapperTeacherPage(index: 0),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4FB3B7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
                child: Text(
                  l10n.ok,
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
      ),
    );
  }

  Widget drawer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: const Color(0xff061438),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xff061438),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xff4FB3B7),
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.08,
                  width: screenHeight * 0.08,
                  child: Image.asset("assets/images/brain_logo.png"),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "QUIZLY",
                  style: TextStyle(
                    color: const Color(0xff62DDE1),
                    fontSize: screenWidth * 0.085,
                    fontFamily: "DMSerifDisplay",
                  ),
                ),
              ],
            ),
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WrapperTeacherPage()),
            ),
            context,
            const Icon(Icons.home_outlined, color: Color(0xff62DDE1)),
            "Home",
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 1),
              ),
            ),
            context,
            const Icon(Icons.person_outlined, color: Color(0xff62DDE1)),
            "Profile",
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 2),
              ),
            ),
            context,
            const Icon(Icons.list, color: Color(0xff62DDE1)),
            "My Quizzes",
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xff4FB3B7),
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.settings, color: Color(0xff62DDE1)),
              title: Text(
                "Setting",
                style: TextStyle(
                  color: const Color(0xff62DDE1),
                  fontSize: screenWidth * 0.06,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WrapperTeacherPage(index: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listtitle(
    Function callback,
    BuildContext context,
    Icon icon,
    String txt,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xff4FB3B7),
            width: screenHeight * 0.001,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        leading: icon,
        title: Text(
          txt,
          style: TextStyle(
            color: const Color(0xff62DDE1),
            fontSize: screenWidth * 0.06,
          ),
        ),
        onTap: () => callback(),
      ),
    );
  }
}
