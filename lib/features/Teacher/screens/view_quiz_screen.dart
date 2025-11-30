import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewQuizScreen extends StatefulWidget {
  final String title;
  final String createdAt;
  final String duration;
  final String quizzesId;
  final List<Map<String, dynamic>> questions;
  const ViewQuizScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.questions,
    required this.createdAt,
    required this.quizzesId,
  });

  @override
  State<ViewQuizScreen> createState() => _ViewQuizScreenState();
}

class _ViewQuizScreenState extends State<ViewQuizScreen> {
  int currentPage = 0;
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentQuestion = widget.questions[currentPage];

    return Scaffold(
      endDrawer: drawer(context),
      appBar: AppBar(
        title: Text(
          'View Quiz',
          style: GoogleFonts.irishGrover(
            textStyle: TextStyle(
              fontSize: screenWidth * 0.07,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xff061438),
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * .02),
              container(
                context,
                screenHeight * .00008,
                screenWidth * .00009,
                widget.title,
                widget.createdAt,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.53,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: widget.questions.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final question = widget.questions[index];
                      return containerQuestion(
                        context,
                        index,
                        widget.questions[index]["question"]?.toString() ??
                            "No Question",
                        List<String>.from(
                          widget.questions[index]["option"] ?? [],
                        ),
                        widget.questions[index]["answer"]?.toString() ?? "",
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        "Duration (Min)",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      subtitle: TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: widget.duration,
                          hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: const Color(0xff000920),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0x1877F21C),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xff1ABC9C),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        "Quiz Code",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      subtitle: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff455A64),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.quizzesId,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                      backgroundColor:
                          currentPage == 0
                              ? Color(0xff8DA2ABA8)
                              : const Color(0xff4FB3B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed:
                        currentPage > 0
                            ? () {
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                currentPage--;
                              });
                            }
                            : null,
                    child: Text(
                      "Prev",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * .035),
                  TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                      backgroundColor:
                          currentPage == widget.questions.length - 1
                              ? Color(0xff8DA2ABA8)
                              : const Color(0xff4FB3B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed:
                        currentPage < widget.questions.length - 1
                            ? () {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                currentPage++;
                              });
                            }
                            : null,
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget container(
    BuildContext context,
    double heightFactor,
    double widthFactor,
    String txt1,
    String CreatedAt,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        height: screenHeight * heightFactor,
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(bottom: screenHeight * .04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(255, 86, 176, 180),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                txt1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xffFFFFFF),
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              Text(
                "Created on ${CreatedAt}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xffFFFFFF),
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.03,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerField(BuildContext context, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: const Color(0xff1A1C2B),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: const Color(0xff4FB3B7), width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.038,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget containerQuestion(
    BuildContext context,
    int index,
    String questionText,
    List<String> options,
    String correctAnswer,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    int selectedIndex = -1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          decoration: BoxDecoration(
            color: const Color(0xff000920),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            border: Border.all(color: const Color(0xff4FB3B7), width: 2),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Question ${index + 1}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                containerField(context, "Q${index + 1}: $questionText"),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  "Enter options and select correct answer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  children: List.generate(options.length, (i) {
                    bool isCorrect = options[i] == correctAnswer;
                    bool isSelected = i == selectedIndex;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.008,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: screenWidth * 0.06,
                              height: screenWidth * 0.06,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xff4FB3B7),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: screenWidth * 0.03,
                                  height: screenWidth * 0.03,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isCorrect
                                            ? const Color(0xff4FB3B7)
                                            : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                              decoration: InputDecoration(
                                hint: Text(" ${options[i]}"),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff4FB3B7),
                                  ),
                                ),
                                border: InputBorder.none,
                                hintStyle: const TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
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
