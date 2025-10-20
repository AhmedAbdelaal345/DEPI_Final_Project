// import 'package:flutter/material.dart';
// sealed class CreateQuizState {
//   final List<TextEditingController> questions;
//   final List<List <TextEditingController>> options;
//   final List<TextEditingController> answers;
//   const CreateQuizState({
//     required this.options,
//     required this.questions,
//     required this.answers,
//   });
// }
// class CreateQuizInitial extends CreateQuizState {
//   CreateQuizInitial()
//       : super(
//           questions: [],
//           options: [],
//           answers: [],
//         );
// }
// class CreateQuizUpdated extends CreateQuizState {
//   const CreateQuizUpdated({
//     required super.options, 
//     required super.questions,
//     required super.answers,
//   });
// }
// class CreateQuizSaved extends CreateQuizState {
//   const CreateQuizSaved({
//     required super.options, 
//     required super.questions,
//     required super.answers,
//   });
// }
// class CreateQuizLoading extends CreateQuizState {
//   const CreateQuizLoading({
//     required super.options, 
//     required super.questions,
//     required super.answers,
//   });
// }
// class CreateQuizError extends CreateQuizState {
//   final String message;
//   const CreateQuizError({
//     required super.options, 
//     required super.questions,
//     required super.answers,
//     required this.message,
//   });
// }
// class GetQuiz  extends CreateQuizState {
//    List <dynamic> quizList;
//    List <dynamic> quizzesId;
//   GetQuiz ({required this.quizzesId,required this.quizList,required super.options, required super.questions, required super.answers});
// }
// class GetQuizError  extends CreateQuizState {
//   String message;
//   GetQuizError ({required super.questions,required super.options,  required super.answers,required this.message});
// }
