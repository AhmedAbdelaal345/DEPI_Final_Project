import 'package:depi_final_project/features/Teacher/screens/homeTeacher.dart';
import 'package:depi_final_project/features/Teacher/screens/quizcreatesuccesfully.dart';
import 'package:depi_final_project/features/home/presentation/Screens/profile_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';


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

  @override
  void dispose() {
    durationController.dispose();
    quizTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cubit        = context.read<CreateQuizCubit>();
    final l10n = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cubit.state.questions.isEmpty) {
        cubit.addqeustion();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xff000920),
      resizeToAvoidBottomInset: true,
      endDrawer: drawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xff000920),
        centerTitle: true,
        title: Text(
          l10n.createNewQuiz,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
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
                  context,
                  quizTitle,
                  l10n.enterQuizTitle,
                ),
              ),
              Expanded(
                child: BlocBuilder<CreateQuizCubit, CreateQuizState>(
                  builder: (context, state) {
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
                            );
                          }),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title:  Text(
                                    l10n.durationInMinutes,
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  subtitle: TextFormField(
                                    controller: durationController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.thisFieldRequired;
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
                                  title:  Text(
                                    l10n.quizCode,
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
                                        l10n.create,
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
  }

  //================ Helper Widgets ==================
  Widget containerField(BuildContext context, TextEditingController controller, String hint) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context);
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
            return l10n.thisFieldRequired;
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
  ) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    int selectedIndex  = -1;
    final l10n = AppLocalizations.of(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.questionNumber(index + 1),
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => cubit.addqeustion(),
                    child: Text(
                      l10n.addQuestion,
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              containerField(context, questionController, l10n.enterQuestion),
              SizedBox(height: screenHeight * 0.015),
              Text(
                l10n.enterOptionsAndSelectCorrect,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Column(
                children: List.generate(optionControllers.length, (i) {
                  bool isSelected = i == selectedIndex;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = i;
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
                                  color: isSelected
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
                            controller: optionControllers[i],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.thisFieldRequired;
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
    final l10n = AppLocalizations.of(context);
    return Drawer(
      backgroundColor: const Color(0xff061438),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff061438),
              border: Border(bottom: BorderSide(color: Color(0xff4FB3B7))),
            ),
            child: Row(
              children: [
                Image.asset("assets/images/brain_logo.png"),
                Text(
                  l10n.appName,
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
              MaterialPageRoute(builder: (_) => const Hometeacher()),
            ),
            context,
            const Icon(Icons.home_outlined, color: Color(0xff62DDE1)),
            l10n.home,
          ),
          listtitle(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            context,
            const Icon(Icons.person_outlined, color: Color(0xff62DDE1)),
            l10n.profile,
          ),
          listtitle(
            () {},
            context,
            const Icon(Icons.list, color: Color(0xff62DDE1)),
            l10n.myQuizzes,
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xff62DDE1)),
            title: Text(
              l10n.settings,
              style: TextStyle(
                color: const Color(0xff62DDE1),
                fontSize: screenWidth * 0.06,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listtitle(Function callback, BuildContext context, Icon icon, String txt) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff4FB3B7))),
      ),
      child: ListTile(
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
