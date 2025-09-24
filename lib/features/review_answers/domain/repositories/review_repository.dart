import '../entities/review_question.dart';

abstract class ReviewRepository {
  // وظيفة لإحضار قائمة بالأسئلة التي تمت الإجابة عليها بشكل صحيح
  Future<List<ReviewQuestion>> getCorrectAnswers();

  // وظيفة لإحضار قائمة بالأسئلة التي تمت الإجابة عليها بشكل خاطئ
  Future<List<ReviewQuestion>> getWrongAnswers();
}