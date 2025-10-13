import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/features/questions/presentation/model/question_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultCubit extends Cubit<void> {
  ResultCubit() : super(null);

Future<void> saveStudentQuizResult({
  required String studentId,
  required String quizId,
  required List<Map<String, dynamic>> questionsWithAnswers,
  required List<QuestionModel> questions,
  required String status,
}) async {
  try {
    // Calculate score
    int correctAnswers = 0;
   

    for (var answer in questionsWithAnswers) {
  final userAnswer = answer['selectedAnswer'] ?? answer['userAnswer'];
  final correctAnswer = answer['correctAnswer'];

  if (userAnswer != null && correctAnswer != null && userAnswer == correctAnswer) {
    correctAnswers++;
  }
}


    final int total = questions.length;

    final quizDoc = FirebaseFirestore.instance
        .collection('Student')
        .doc(studentId)
        .collection('quizzes')
        .doc(quizId);

    // ✅ check if already exists
    final existing = await quizDoc.get();
    if (existing.exists) {
  print('🔄 Updating existing quiz result for quiz: $quizId');
    }
final double accuracy = total == 0 ? 0.0 : correctAnswers / total;

    // Prepare data to save
    final Map<String, dynamic> quizResultData = {
      'score': correctAnswers,
      'total': total,
        'accuracy': accuracy,

      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'details': questionsWithAnswers,
    };

    await quizDoc.set(quizResultData, SetOptions(merge: true));

    print('✅ Quiz result saved successfully for student: $studentId, quiz: $quizId');
  } catch (e) {
    print('❌ Error saving quiz result: $e');
    rethrow;
  }
}
}