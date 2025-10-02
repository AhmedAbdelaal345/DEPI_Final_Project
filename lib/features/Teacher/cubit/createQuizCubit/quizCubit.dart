 import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
CreateQuizCubit() : super(CreateQuizInitial()){
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
Future<String?> getname(String uid)async{
 final doc = await FirebaseFirestore.instance
      .collection("teacher")
      .doc(uid)
      .get();
  if (doc.exists) {
    return doc['fullName']; 
  } else {
    return null; 
  }
}
Future<String?> getsubject(String uid)async{
 final doc = await FirebaseFirestore.instance
      .collection("teacher")
      .doc(uid)
      .get();

  if (doc.exists) {
    return doc['subject']; 
  } else {
    return null; 
  }
}
  void addqeustion( )async{
  final newQuestion= List<TextEditingController>.from(state.questions);
  final newOptions=List<List<TextEditingController>>.from(state.options);
  final newAnswer=List<TextEditingController>.from(state.answers);
  emit(CreateQuizUpdated(options: newOptions..add([TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()]),questions: newQuestion..add( TextEditingController()),answers: newAnswer..add(TextEditingController())));
  }
  void removeqeustion(int index,String docId){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // نسخة جديدة علشان نشوف ال state اتغيرت ولا لا
  final newQuestion= List<TextEditingController>.from(state.questions);
  final newOptions=List<List<TextEditingController>>.from(state.options);
  final newAnswer=List<TextEditingController>.from(state.answers);
  if (index >= 0 && index < newQuestion.length) {
      Map<String, dynamic> questionMap = {
      "question": newQuestion[index].text.trim(),
      "answer": newAnswer[index].text.trim(),
      "option":newOptions[index].map((c) => c.text.trim()).toList()
    };
        firestore.collection("quizzes").doc(docId).update({
            "questions": FieldValue.arrayRemove([questionMap])
  });
    newQuestion.removeAt(index);
    newAnswer.removeAt(index);
    emit(CreateQuizUpdated(
      options: newOptions,
      questions: newQuestion,
      answers: newAnswer,
    ));
  }
  }
  savedQuiz(String iddoc,String duration ,int qeustionCount,String subject,String teacherId,String title,String uid) async{
    try {
    CollectionReference quiz = FirebaseFirestore.instance.collection(
      "Quizzes",
    );
    final newQuestion = List<TextEditingController>.from(state.questions);
    final newOptions=List<List<TextEditingController>>.from(state.options);
    final newAnswer = List<TextEditingController>.from(state.answers);
    List<Map<String, dynamic>> question = [];
    for (int i = 0; i < newQuestion.length; i++) {
      question.add({
        "question": newQuestion[i].text,
        "option":newOptions[i].map((c) => c.text.trim()).toList(),
        "answer": newAnswer[i].text,
      });
    }
    final quizRef = quiz.doc(iddoc.trim());
     await quiz.doc(iddoc.trim()).set({
      "createdAt": DateTime.now(),
      "duration":duration,
      "question_count":qeustionCount,
      "subject":subject,
      "teacherId":teacherId,
      "title":title,
      "uid": uid,
    });
    for (int i = 0; i < question.length; i++) {
  await quizRef.collection("questions").doc("q${i+1}").set({
    "question": question[i]["question"],
    "option": question[i]["option"],
    "answer": question[i]["answer"],
  });
}
    emit(CreateQuizSaved(options: newOptions,questions: newQuestion,answers: newAnswer));
  }
   catch (e) {
      emit(CreateQuizError(
        options:state.options ,
        questions: state.questions,
        answers: state.answers,
        message: e.toString(),
      ));
    }
  }
}