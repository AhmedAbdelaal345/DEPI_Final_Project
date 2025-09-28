
import '../../domain/entities/review_question.dart';
import '../../domain/repositories/review_repository.dart';

// هذا الكلاس ينفذ العقد عن طريق إرجاع بيانات وهمية
class MockReviewRepositoryImpl implements ReviewRepository {

  @override
  Future<List<ReviewQuestion>> getCorrectAnswers() async {
    // لمحاكاة انتظار تحميل البيانات من الإنترنت
    await Future.delayed(const Duration(seconds: 1));

    // إرجاع قائمة وهمية من الإجابات الصحيحة
    return [
      ReviewQuestion(
        id: 'Q1',
        questionText: 'What is the capital of France?',
        options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
        correctAnswer: 'Paris',
        userAnswer: 'Paris',
      ),
      ReviewQuestion(
        id: 'Q2',
        questionText: 'What is 5 + 3?',
        options: ['5', '7', '8', '9'],
        correctAnswer: '8',
        userAnswer: '8',
      ),
      ReviewQuestion(
        id: 'Q3',
        questionText: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswer: 'Mars',
        userAnswer: 'Mars',
      ),
      ReviewQuestion(
        id: 'Q4',
        questionText: 'What is the square root of 64?',
        options: ['6', '7', '8', '9'],
        correctAnswer: '8',
        userAnswer: '8',
      ),
      ReviewQuestion(
        id: 'Q5',
        questionText: 'Who wrote "Hamlet"?',
        options: ['Shakespeare', 'Homer', 'Dante', 'Goethe'],
        correctAnswer: 'Shakespeare',
        userAnswer: 'Shakespeare',
      ),
    ];

  }

  @override
  Future<List<ReviewQuestion>> getWrongAnswers() async {
    // لمحاكاة انتظار تحميل البيانات من الإنترنت
    await Future.delayed(const Duration(seconds: 1));

    // إرجاع قائمة وهمية من الإجابات الخاطئة (مطابقة للتصميم)
    return [
      ReviewQuestion(
        id: 'Q6',
        questionText: 'What is the capital of Germany?',
        options: ['Berlin', 'Paris', 'Rome', 'Madrid'],
        correctAnswer: 'Berlin',
        userAnswer: 'Paris', // خاطئة
      ),
      ReviewQuestion(
        id: 'Q7',
        questionText: 'What is 10 × 2?',
        options: ['10', '15', '20', '25'],
        correctAnswer: '20',
        userAnswer: '25', // خاطئة
      ),
      ReviewQuestion(
        id: 'Q8',
        questionText: 'Which gas do humans need to breathe?',
        options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Helium'],
        correctAnswer: 'Oxygen',
        userAnswer: 'Nitrogen', // خاطئة
      ),
      ReviewQuestion(
        id: 'Q9',
        questionText: 'What is the freezing point of water (°C)?',
        options: ['0', '50', '100', '-10'],
        correctAnswer: '0',
        userAnswer: '100', // خاطئة
      ),
      ReviewQuestion(
        id: 'Q10',
        questionText: 'Which continent is Egypt located in?',
        options: ['Asia', 'Europe', 'Africa', 'Australia'],
        correctAnswer: 'Africa',
        userAnswer: 'Asia', // خاطئة
      ),
    ];

  }
}