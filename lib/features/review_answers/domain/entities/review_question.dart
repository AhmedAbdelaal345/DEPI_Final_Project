class ReviewQuestion {
  final String id; // ID فريد لكل سؤال
  final String questionText; // نص السؤال
  final List<String> options; // قائمة الاختيارات
  final String correctAnswer; // الإجابة الصحيحة
  final String userAnswer;    // إجابة المستخدم
  final int correctAnswerIndex;    // إجابة المستخدم
  final  int  userAnswerIndex;
 final String explanation ;   // إجابة المستخدم

  ReviewQuestion({
    required this.id,
    required this.questionText,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.userAnswer,
    required this.options,
    required this.correctAnswer,
    required this.userAnswerIndex,});

  // هذه دالة بسيطة لتسهيل معرفة إذا كانت الإجابة صحيحة أم لا
  bool get isCorrect => correctAnswer == userAnswer;
}