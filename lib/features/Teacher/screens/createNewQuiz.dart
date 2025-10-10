import 'package:depi_final_project/features/Teacher/screens/homeTeacher.dart';
import 'package:depi_final_project/features/Teacher/screens/quizcreatesuccesfully.dart';
import 'package:depi_final_project/features/Teacher/wrapper_teacher_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/profile_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';

class Createnewquiz extends StatefulWidget {
  final String teacherId;
  final String subject;
  final String quizId;
  final String uid;

  const Createnewquiz({
    required this.quizId,
    required this.subject,
    required this.teacherId,
    required this.uid,
    super.key,
  });

  @override
  State<Createnewquiz> createState() => _CreatenewquizState();
}

class _CreatenewquizState extends State<Createnewquiz> {
  final TextEditingController durationController = TextEditingController();
  final TextEditingController quizTitle = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CreateQuizCubit>();
      if (cubit.state.questions.isEmpty) {
        cubit.addqeustion();
      }
    });
  }

  @override
  void dispose() {
    durationController.dispose();
    quizTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (builderContext) {
        final screenWidth = MediaQuery.of(builderContext).size.width;
        final screenHeight = MediaQuery.of(builderContext).size.height;

        return Scaffold(
          backgroundColor: const Color(0xff000920),
          resizeToAvoidBottomInset: true,
          endDrawer: drawer(builderContext),
          appBar: AppBar(
            backgroundColor: const Color(0xff000920),
            centerTitle: true,
            title: Text(
              "Create New Quiz",
              style: TextStyle(
                fontFamily: 'Judson',
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    child: containerField(
                      builderContext,
                      quizTitle,
                      "Enter Quiz title",
                      screenWidth,
                      screenHeight,
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<CreateQuizCubit, CreateQuizState>(
                      builder: (context, state) {
                        final cubit = context.read<CreateQuizCubit>();

                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: screenHeight * 0.02),
                              // List of questions
                              ...List.generate(state.questions.length, (index) {
                                return containerQuestion(
                                  context,
                                  index,
                                  state.questions[index],
                                  state.options[index],
                                  state.answers[index],
                                  cubit,
                                  screenWidth,
                                  screenHeight,
                                );
                              }),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: const Text(
                                        "Duration (Min)",
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                      subtitle: TextFormField(
                                        controller: durationController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "This Field required";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintStyle: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white54,
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
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ListTile(
                                      title: const Text(
                                        "Quiz Code",
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                      subtitle: Container(
                                        height: 60,
                                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff455A64),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          widget.quizId,
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
                              const SizedBox(height: 20),
                              BlocConsumer<CreateQuizCubit, CreateQuizState>(
                                listener: (context, state) {
                                  if (state is CreateQuizSaved) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizCreateSuccessful(quizId: widget.quizId),
                                      ),
                                    );
                                    durationController.clear();
                                    quizTitle.clear();
                                    cubit.resetQuiz();
                                  } else if (state is CreateQuizError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: Size(
                                        screenWidth * 0.9,
                                        screenHeight * 0.06,
                                      ),
                                      backgroundColor: const Color(0xff4FB3B7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: state is CreateQuizLoading
                                        ? null
                                        : () {
                                            if (key.currentState!.validate()) {
                                              bool allAnswered = true;
                                              for (int i = 0; i < cubit.state.answers.length; i++) {
                                                if (cubit.state.answers[i].text.isEmpty) {
                                                  allAnswered = false;
                                                  break;
                                                }
                                              }

                                              if (!allAnswered) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Please select a correct answer for all questions"),
                                                  ),
                                                );
                                                return;
                                              }
                                              cubit.savedQuiz(
                                                widget.quizId,
                                                durationController.text.trim(),
                                                cubit.state.questions.length,
                                                widget.subject,
                                                widget.teacherId,
                                                quizTitle.text.trim(),
                                                widget.uid,
                                              );
                                            }
                                          },
                                    child: state is CreateQuizLoading
                                        ? const CircularProgressIndicator(color: Color(0xff4FB3B7))
                                        : Text(
                                            "Create",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.06,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //================ Helper Widgets ==================
  Widget containerField(
    BuildContext context,
    TextEditingController controller,
    String hint,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight * 0.08,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xff1A1C2B),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: const Color(0xff4FB3B7), width: 2),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This Field required";
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: screenWidth * 0.038,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.038,
          ),
        ),
      ),
    );
  }

  Widget containerQuestion(
    BuildContext context,
    int index,
    TextEditingController questionController,
    List<TextEditingController> optionControllers,
    TextEditingController answerController,
    CreateQuizCubit cubit,
    double screenWidth,
    double screenHeight,
  ) {
    return StatefulBuilder(
      builder: (builderContext, setState) {
        return Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          decoration: BoxDecoration(
            color: const Color(0xff000920),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            border: Border.all(color: const Color(0xff4FB3B7), width: 2),
          ),
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
                  TextButton(
                    onPressed: () => cubit.addqeustion(),
                    child: Text(
                      "Add Question",
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              containerField(context, questionController, "Enter Question", screenWidth, screenHeight),
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
                children: List.generate(optionControllers.length, (i) {
                  bool isSelected = _selectedAnswers[index] == i;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAnswers[index] = i;
                              answerController.text = optionControllers[i].text;
                            });
                          },
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
                                  color: isSelected ? const Color(0xff4FB3B7) : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: TextFormField(
                            controller: optionControllers[i],
                            onChanged: (value) {
                              if (_selectedAnswers[index] == i) {
                                answerController.text = value;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This Field required";
                              }
                              return null;
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff4FB3B7)),
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white54),
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
            MaterialPageRoute(builder: (_) => const WrapperTeacherPage(index: 1)),
          ),
          context,
          const Icon(Icons.person_outlined, color: Color(0xff62DDE1)),
          "Profile",
        ),
        listtitle(
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WrapperTeacherPage(index: 2)),
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
                MaterialPageRoute(builder: (_) => const WrapperTeacherPage(index: 3)),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget listtitle(Function callback, BuildContext context, Icon icon, String txt) {
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
