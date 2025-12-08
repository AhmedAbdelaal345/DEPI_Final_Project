import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      endDrawer: drawer(context),
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
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
                            color: Colors.green,
                            width: screenWidth * 0.015,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
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
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      l10n.quizCreatedMessage,
                      style: TextStyle(
                        color: AppColors.white,
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
                  backgroundColor: AppColors.grey,
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
                        color: AppColors.white,
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
                      icon: Icon(Icons.copy, color: AppColors.white),
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
                  backgroundColor: AppColors.primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
                child: Text(
                  l10n.ok,
                  style: TextStyle(
                    color: AppColors.black,
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
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.secondaryBackground,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryTeal,
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.08,
                  width: screenHeight * 0.08,
                  child: Image.asset(AppConstants.brainLogo),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  l10n.appName,
                  style: TextStyle(
                    color: AppColors.secondaryTeal,
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
            Icon(Icons.home_outlined, color: AppColors.secondaryTeal),
            l10n.home,
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 1),
              ),
            ),
            context,
            Icon(Icons.person_outlined, color: AppColors.secondaryTeal),
            l10n.profile,
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperTeacherPage(index: 2),
              ),
            ),
            context,
            Icon(Icons.list, color: AppColors.secondaryTeal),
            l10n.myQuizzes,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryTeal,
                  width: screenHeight * 0.001,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.settings, color: AppColors.secondaryTeal),
              title: Text(
                l10n.setting,
                style: TextStyle(
                  color: AppColors.secondaryTeal,
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
            color: AppColors.primaryTeal,
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
            color: AppColors.secondaryTeal,
            fontSize: screenWidth * 0.06,
          ),
        ),
        onTap: () => callback(),
      ),
    );
  }
}
