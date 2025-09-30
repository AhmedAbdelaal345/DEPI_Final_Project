class QuestionModel {
  final String text;
  final Map<String, String> options;
  final String correctAnswer;
  final int? points;
  final DateTime? createdAt;

  QuestionModel({
    required this.text,
    required this.options,
    required this.correctAnswer,
    this.points,
    this.createdAt,
  });

  factory QuestionModel.fromFirestore(Map<String, dynamic> json) {
    try {
      // Get text field (it's already 'text' in Firebase)
      final String questionText = json['text'] ?? '';
      
      // Handle options - convert to Map<String, String>
      Map<String, String> questionOptions = {};
      if (json['options'] != null) {
        final optionsData = json['options'];
        if (optionsData is Map) {
          questionOptions = Map<String, String>.from(optionsData);
        }
      }
      
      // Handle correct answer - it's 'Correct_Answer' in Firebase
      final String correctAns = json['Correct_Answer'] ?? '';

      // Handle points
      int? questionPoints;
      if (json['points'] != null) {
        if (json['points'] is String) {
          questionPoints = int.tryParse(json['points']);
        } else {
          questionPoints = json['points'] as int?;
        }
      }

      // Handle createdAt
      DateTime? createdAtDate;
      if (json['createdAt'] != null) {
        if (json['createdAt'] is String) {
          createdAtDate = DateTime.tryParse(json['createdAt']);
        }
      }

      print('Parsed Question from Firebase:');
      print('  Text: $questionText');
      print('  Options: $questionOptions');
      print('  Correct Answer: $correctAns');
      print('  Points: $questionPoints');

      if (questionText.isEmpty) {
        throw Exception('Question text is empty');
      }
      
      if (questionOptions.isEmpty) {
        throw Exception('Question options are empty');
      }
      
      if (correctAns.isEmpty) {
        throw Exception('Correct answer is empty');
      }

      return QuestionModel(
        text: questionText,
        options: questionOptions,
        correctAnswer: correctAns,
        points: questionPoints,
        createdAt: createdAtDate,
      );
    } catch (e) {
      print('Error parsing QuestionModel from Firestore:');
      print('Error: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'options': options,
      'Correct_Answer': correctAnswer, // Use the same field name as in Firestore
      'points': points?.toString(),
      'createdAt': createdAt?.toIso8601String(),
      
    };
  }

  @override
  String toString() {
    return 'QuestionModel(text: $text, options: $options, correctAnswer: $correctAnswer, points: $points)';
  }
}