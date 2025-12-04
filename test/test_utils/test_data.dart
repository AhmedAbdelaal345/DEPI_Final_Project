import 'package:depi_final_project/features/profile/data/models/user_profile_model.dart';
import 'package:depi_final_project/features/home/data/models/quiz_model.dart';

class TestData {
  // Test User Profiles
  static final studentProfile = UserProfileModel(
    uid: 'test-student-123',
    fullName: 'Test Student',
    email: 'student@test.com',
    role: 'student',
    isProActive: false,
    createdAt: DateTime(2024, 1, 1),
  );

  static final proStudentProfile = UserProfileModel(
    uid: 'test-pro-student-123',
    fullName: 'Pro Student',
    email: 'pro@test.com',
    role: 'student',
    isProActive: true,
    proExpiryDate: DateTime.now().add(const Duration(days: 30)),
    createdAt: DateTime(2024, 1, 1),
  );

  static final teacherProfile = UserProfileModel(
    uid: 'test-teacher-123',
    fullName: 'Test Teacher',
    email: 'teacher@test.com',
    role: 'teacher',
    isProActive: false,
    createdAt: DateTime(2024, 1, 1),
  );

  // Test Quiz Data
  static final sampleQuiz = {
    'id': 'quiz-123',
    'title': 'Sample Quiz',
    'subject': 'Mathematics',
    'difficulty': 'Medium',
    'totalQuestions': 10,
    'duration': 30,
    'createdBy': 'test-teacher-123',
    'createdAt': DateTime(2024, 1, 15),
  };

  static final completedQuiz = {
    'id': 'quiz-completed-123',
    'title': 'Completed Quiz',
    'subject': 'Science',
    'score': 8,
    'total': 10,
    'completedAt': DateTime(2024, 1, 20),
  };

  // Test Questions
  static final sampleQuestions = [
    {
      'id': 'q1',
      'question': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
      'correctAnswer': 'B',
      'explanation': '2 + 2 equals 4',
    },
    {
      'id': 'q2',
      'question': 'What is the capital of France?',
      'options': ['London', 'Paris', 'Berlin', 'Madrid'],
      'correctAnswer': 'B',
      'explanation': 'Paris is the capital of France',
    },
    {
      'id': 'q3',
      'question': 'What is 10 / 2?',
      'options': ['3', '4', '5', '6'],
      'correctAnswer': 'C',
      'explanation': '10 divided by 2 equals 5',
    },
  ];

  // Test Answers
  static final correctAnswers = {
    0: 'B',
    1: 'B',
    2: 'C',
  };

  static final mixedAnswers = {
    0: 'B', // Correct
    1: 'A', // Wrong
    2: 'C', // Correct
  };

  static final allWrongAnswers = {
    0: 'A',
    1: 'A',
    2: 'A',
  };
}
