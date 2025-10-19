import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  CreateQuizCubit() : super(CreateQuizInitial()) {}

  void resetQuiz() {
    for (var controller in state.questions) {
      controller.dispose();
    }
    for (var optionList in state.options) {
      for (var controller in optionList) {
        controller.dispose();
      }
    }
    for (var controller in state.answers) {
      controller.dispose();
    }
    emit(CreateQuizInitial());
  }

  Future<String> getSixRandomNumbers() async {
    final random = Random();
    final database = FirebaseFirestore.instance.collection("quizzes");
    while (true) {
      String quizid = '';
      for (int i = 0; i < 6; i++) {
        quizid += random.nextInt(10).toString();
      }
      final doc = await database.doc(quizid).get();
      if (!doc.exists) {
        return quizid;
      }
    }
  }

  Future<String?> getname(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("teacher").doc(uid).get();
    if (doc.exists) {
      return doc['fullName'];
    } else {
      return null;
    }
  }

  Future<String?> getsubject(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("teacher").doc(uid).get();

    if (doc.exists) {
      return doc['subject'];
    } else {
      return null;
    }
  }

  void addqeustion() async {
    final newQuestion = List<TextEditingController>.from(state.questions);
    final newOptions = List<List<TextEditingController>>.from(state.options);
    final newAnswer = List<TextEditingController>.from(state.answers);
    emit(
      CreateQuizUpdated(
        options:
            newOptions..add([
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ]),
        questions: newQuestion..add(TextEditingController()),
        answers: newAnswer..add(TextEditingController()),
      ),
    );
  }

  void removeqeustion(int index, String docId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // نسخة جديدة علشان نشوف ال state اتغيرت ولا لا
    final newQuestion = List<TextEditingController>.from(state.questions);
    final newOptions = List<List<TextEditingController>>.from(state.options);
    final newAnswer = List<TextEditingController>.from(state.answers);
    if (index >= 0 && index < newQuestion.length) {
      Map<String, dynamic> questionMap = {
        "question": newQuestion[index].text.trim(),
        "answer": newAnswer[index].text.trim(),
        "option": newOptions[index].map((c) => c.text.trim()).toList(),
      };
      firestore.collection("quizzes").doc(docId).update({
        "questions": FieldValue.arrayRemove([questionMap]),
      });
      newQuestion.removeAt(index);
      newAnswer.removeAt(index);
      emit(
        CreateQuizUpdated(
          options: newOptions,
          questions: newQuestion,
          answers: newAnswer,
        ),
      );
    }
  }

  savedQuiz(
    String iddoc,
    String duration,
    int qeustionCount,
    String subject,
    String teacherId,
    String title,
    String uid,
  ) async {
    try {
      CollectionReference quiz = FirebaseFirestore.instance.collection(
        "Quizzes",
      );
      final newQuestion = List<TextEditingController>.from(state.questions);
      final newOptions = List<List<TextEditingController>>.from(state.options);
      final newAnswer = List<TextEditingController>.from(state.answers);
      List<Map<String, dynamic>> question = [];
      for (int i = 0; i < newQuestion.length; i++) {
        question.add({
          "question": newQuestion[i].text,
          "option": newOptions[i].map((c) => c.text.trim()).toList(),
          "answer": newAnswer[i].text,
        });
      }
      final quizRef = quiz.doc(iddoc.trim());
      await quiz.doc(iddoc.trim()).set({
        "createdAt": DateTime.now(),
        "duration": duration,
        "question_count": qeustionCount,
        "subject": subject,
        "teacherId": teacherId,
        "title": title,
        "uid": uid,
        "quizid": iddoc,
      });
      for (int i = 0; i < question.length; i++) {
        await quizRef.collection("questions").doc("q${i + 1}").set({
          "question": question[i]["question"],
          "option": question[i]["option"],
          "answer": question[i]["answer"],
        });
      }
      emit(
        CreateQuizSaved(
          options: newOptions,
          questions: newQuestion,
          answers: newAnswer,
        ),
      );
    } catch (e) {
      emit(
        CreateQuizError(
          options: state.options,
          questions: state.questions,
          answers: state.answers,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getquizzes(String uid) async {
    List<Map<String, dynamic>> newQuizList = [];

    try {
      final newQuestion = List<TextEditingController>.from(state.questions);
      final newOptions = List<List<TextEditingController>>.from(state.options);
      final newAnswer = List<TextEditingController>.from(state.answers);


      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection("Quizzes")
              .orderBy("createdAt", descending: true)
              .get();
      final userQuizzes =
          querySnapshot.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data["uid"] == uid;
          }).toList();
      final quizIds = querySnapshot.docs.map((doc) => doc.id).toList();
      final futures = userQuizzes.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;

        QuerySnapshot questionSnapshot =
            await FirebaseFirestore.instance
                .collection("Quizzes")
                .doc(doc.id)
                .collection("questions")
                .get();
        List<Map<String, dynamic>> questionList =
            questionSnapshot.docs.map((q) {
              final qData = q.data() as Map<String, dynamic>;
              return {
                "question": qData["question"] ?? "",
                "option": List<String>.from(qData["option"] ?? []),
                "answer": qData["answer"] ?? "",
              };
            }).toList();

        data["questions"] = questionList;

        return data;
      });
      final quizzesWithQuestions = await Future.wait(futures);
      newQuizList = quizzesWithQuestions;
      emit(
        GetQuiz(
          quizzesId: quizIds,
          quizList: newQuizList,
          options: newOptions,
          questions: newQuestion,
          answers: newAnswer,
        ),
      );
    } catch (e) {
      final newQuestion = List<TextEditingController>.from(state.questions);
      final newOptions = List<List<TextEditingController>>.from(state.options);
      final newAnswer = List<TextEditingController>.from(state.answers);
      emit(
        GetQuizError(
          options: newOptions,
          questions: newQuestion,
          answers: newAnswer,
          message: e.toString(),
        ),
      );
    }
  }

  Future<bool> removeQuiz(String quizId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final quizRef = firestore.collection('Quizzes').doc(quizId);
      final quizDoc = await quizRef.get();
      if (!quizDoc.exists) {
        return false;
      }
      final questionsSnapshot = await quizRef.collection('questions').get();
      for (var questionDoc in questionsSnapshot.docs) {
        await questionDoc.reference.delete();
      }
      await quizRef.delete();
      final verifyDoc = await quizRef.get();

      if (state is GetQuiz) {
        final quizState = state as GetQuiz;

        final newQuestion = List<TextEditingController>.from(state.questions);
        final newOptions = List<List<TextEditingController>>.from(
          state.options,
        );
        final newAnswer = List<TextEditingController>.from(state.answers);

        final newQuizList = List<Map<String, dynamic>>.from(quizState.quizList)
          ..removeWhere((quiz) => quiz['quizid'] == quizId);
        final newQuizzesId = List<String>.from(quizState.quizzesId)
          ..remove(quizId);

        emit(
          GetQuiz(
            options: newOptions,
            questions: newQuestion,
            answers: newAnswer,
            quizzesId: newQuizzesId,
            quizList: newQuizList,
          ),
        );
      }

      return true;
    } catch (e) {
      emit(
        GetQuizError(
          options: state.options,
          questions: state.questions,
          answers: state.answers,
          message: 'Failed to delete quiz',
        ),
      );

      return false;
    }
  }

  Future<List<String>> getQuiz(String uid, String title) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection("Quizzes")
              .where("uid", isEqualTo: uid)
              .where("title", isEqualTo: title)
              .get();
      final quizzes =
          querySnapshot.docs.map((doc) => doc["quizid"] as String).toList();

      return quizzes;
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> gettitle(String uid) async {
    final List<String> titles = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Quizzes").get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null &&
            data["uid"] != null &&
            data["title"] != null &&
            data["uid"] == uid) {
          titles.add(data["title"] as String);
        }
      }

      return titles;
    } catch (e) {
      print('Error in gettitle: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsForQuiz(String quizId) async {
    final firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> results = [];

    try {
      final studentsSnapshot = await firestore.collection('Student').get();

      for (var studentDoc in studentsSnapshot.docs) {
        final studentData = studentDoc.data();

        final questionDoc =
            await studentDoc.reference.collection('questions').doc(quizId).get();

        if (questionDoc.exists) {
          final quizData = questionDoc.data();

          // score may be stored as fraction (0..1) OR as raw count
          final num rawScore = (quizData?['score'] ?? 0) as num;
          final double scoreVal = rawScore.toDouble();
          final int total = ((quizData?['total'] ?? 0) as num).toInt();
          final String status = (quizData?['status'] ?? 'Pending') as String;

          // compute percentage robustly
          double percent;
          if (total > 1) {
            // if score looks like a fraction (<=1), multiply by 100; otherwise divide by total
            percent = scoreVal <= 1.0 ? (scoreVal * 100.0) : ((scoreVal / total) * 100.0);
          } else {
            // total missing or 1: treat score as fraction if <=1
            percent = scoreVal <= 1.0 ? (scoreVal * 100.0) : scoreVal;
          }

          results.add({
            'studentName': studentData['fullName'] ?? 'Unknown Student',
            'email': studentData['email'] ?? 'No Email',
            'score': scoreVal,
            'total': total,
            'status': status,
            'averageScore': percent, // percentage 0..100
          });
        }
      }
      int passCount = results.where((r) => r['status'] == 'Pass').length;
      double passRate = results.isEmpty ? 0 : (passCount / results.length) * 100;
      results = results.map((r) {
        r['passRate'] = passRate;
        return r;
      }).toList();
      return results;
    } catch (e) {
      return [];
    }
  }
}
