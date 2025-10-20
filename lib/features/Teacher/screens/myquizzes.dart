import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Myquizzes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Quizzes",
          style: TextStyle(
            fontFamily: 'Judson',
            fontSize: screenWidth * 0.065,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CreateQuizCubit, CreateQuizState>(
        builder: (context, state) {
          if (state is GetQuiz) {
            final quizzes = state.quizList;
            final quizzesid = state.quizzesId;
            if (quizzes.isEmpty) {
              return Center(child: Text("Not Found Quizzes"));
            }

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return container(
                  index,
                  context,
                  screenHeight * .00015,
                  screenWidth * .00009,
                  quiz[AppConstants.title],
                  quiz[AppConstants.quizId] ?? "",
                  quiz[AppConstants.teacherId] ?? "",
                  quiz[AppConstants.createdAt],
                  quiz,
                  quizzesid,
                );
              },
            );
          } else if (state is GetQuizError) {
            return Center(child: Text("Erorr ${state.message}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget container(
    int index,
    BuildContext context,
    double heightFactor,
    double widthFactor,
    String txt,
    String quizid,
    String teacherid,
    dynamic createdAt,
    dynamic quiz,
    List<dynamic> quizzesId,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String formattedDate = "";
    if (createdAt is Timestamp) {
      DateTime date = createdAt.toDate();
      formattedDate = "${date.day}/${date.month}/${date.year}";
    } else if (createdAt is DateTime) {
      formattedDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    } else {
      formattedDate = createdAt?.toString() ?? "Unknown";
    }
    return Center(
      child: Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(top: screenHeight * .02),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    txt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "code $quizid",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.039,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Created on ${formattedDate}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  final cubit = await context
                      .read<CreateQuizCubit>()
                      .removeQuiz(quizid, teacherid);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Quiz "$txt" deleted successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.delete, color: Color(0xff47969E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
