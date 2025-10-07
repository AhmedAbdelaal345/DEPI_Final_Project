// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'QUIZLY';

  @override
  String welcomeBack(Object name) {
    return 'Welcome back! Mr. $name';
  }

  @override
  String get createNewQuiz => 'Create a new Quiz';

  @override
  String get recentQuizzes => 'Recent\n Quizzes';

  @override
  String get performanceReport => 'Performance Report';

  @override
  String get quizCreated => 'Quiz Created';

  @override
  String get quizCreatedMessage =>
      'Anyone who has this code can join and take the quiz.';

  @override
  String get ok => 'OK';

  @override
  String get quizCodeCopied => 'Quiz code copied';

  @override
  String get enterQuizTitle => 'Enter Quiz title';

  @override
  String get durationInMinutes => 'Duration (Min)';

  @override
  String get thisFieldRequired => 'This Field is required';

  @override
  String get quizCode => 'Quiz Code';

  @override
  String get create => 'Create';

  @override
  String questionNumber(Object number) {
    return 'Question $number';
  }

  @override
  String get addQuestion => 'Add Question';

  @override
  String get enterQuestion => 'Enter Question';

  @override
  String get enterOptionsAndSelectCorrect =>
      'Enter options and select correct answer';

  @override
  String get myQuizzes => 'My Quizzes';

  @override
  String get noQuestionsAvailable => 'No Questions Available';

  @override
  String quizId(Object id) {
    return 'Quiz ID: $id';
  }

  @override
  String get onboarding1Title => 'Welcome to QUIZLY !';

  @override
  String get onboarding1Desc =>
      'Test, and track your progress\nany time , any where';

  @override
  String get onboarding2Title => 'For Students';

  @override
  String get onboarding2Desc =>
      'Enter a code, take your quiz,\nand check your results instantly';

  @override
  String get onboarding3Title => 'For Teachers';

  @override
  String get onboarding3Desc =>
      'Create quizzes, auto-grade answers,\nand track student progress';

  @override
  String get onboarding4Title => 'Choose your role and start now!';

  @override
  String get imAStudent => 'I\'m a Student';

  @override
  String get imATeacher => 'I\'m a Teacher';

  @override
  String get login => 'Login';

  @override
  String get welcomeMessage => 'Welcome  ! please enter your details';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get forgotPasswordMessage =>
      'Don’t worry! Enter your email address and we’ll send you a verification code.';

  @override
  String get rememberThisDevice => 'Remember this device';

  @override
  String get orLoginWith => ' OR Login with ';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account? ';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get errorInvalidCredential =>
      'Invalid email or password. Please try again.';

  @override
  String get errorUserNotFound => 'No user found for that email.';

  @override
  String get errorWrongPassword => 'Wrong password provided.';

  @override
  String get errorInvalidEmail => 'Invalid email format.';

  @override
  String get errorUserDisabled => 'This user account has been disabled.';

  @override
  String get errorNetworkRequestFailed =>
      'Network error. Please check your internet connection and try again.';

  @override
  String errorLoginFailed(Object message) {
    return 'Login failed: $message';
  }

  @override
  String get loginSuccessful => 'Login Successful!';

  @override
  String get sendCode => 'Send Code';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get resetLinkSent => 'Reset link sent to your email';

  @override
  String get register => 'Register';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get enterYourPhoneNumber => 'Enter your Phone Number';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get enterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get enterYourFullName => 'Please enter your full name';

  @override
  String get orRegisterWith => ' OR Register with ';

  @override
  String get enterYourSubject => 'Enter your Subject';

  @override
  String get pleaseEnterYourSubject => 'Please enter your Subject';

  @override
  String get errorWeakPassword => 'The password provided is too weak.';

  @override
  String get errorEmailInUse => 'The account already exists for that email.';

  @override
  String get registrationSuccessful => 'Registration Successful!';

  @override
  String get home => 'Home';

  @override
  String get enterQuizCode => 'Enter quiz code';

  @override
  String get join => 'Join';

  @override
  String get pleaseEnterQuizCode => 'Please enter a quiz code';

  @override
  String get profile => 'Profile';

  @override
  String get allQuizzesTaken => 'All Quizzes taken';

  @override
  String get subjects => 'Subjects';

  @override
  String get averageScore => 'Average Score';

  @override
  String get quizHistory => 'Quiz History';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Manage your notifications';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get toggleTheme => 'Toggle dark/light theme';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change app language';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get getHelpAndSupport => 'Get help and support';

  @override
  String get about => 'About';

  @override
  String get appVersionInfo => 'App version and info';

  @override
  String get teacherScreen => 'Teacher Screen';

  @override
  String get quizNotFound => 'Quiz not found';

  @override
  String get questions => 'Questions';

  @override
  String get timeLimit => 'Time limit';

  @override
  String minutesUnit(Object time) {
    return '$time Mins';
  }

  @override
  String get creator => 'Creator';

  @override
  String get instructions => 'Instructions';

  @override
  String get instruction1 => 'Ensure you have a stable internet connection.';

  @override
  String get instruction2 =>
      'The quiz will automatically submit when the time runs out.';

  @override
  String get instruction3 => 'You cannot pause the quiz once started.';

  @override
  String get startYourJourney => 'Click To Start Your Journey';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get submitQuiz => 'Submit Quiz';

  @override
  String get quizCompleted => 'Quiz Completed!';

  @override
  String get yourPerformanceSummary => 'Your Performance Summary';

  @override
  String get score => 'Score';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get correct => 'Correct';

  @override
  String get wrong => 'Wrong';

  @override
  String get reviewAnswers => 'Review Answers';

  @override
  String get excellentWork => 'Excellent work! 🎉';

  @override
  String get goodJob => 'Good job! 👍';

  @override
  String get notBadKeepPracticing => 'Not bad, keep practicing! 📚';

  @override
  String get keepStudying => 'Keep studying and try again! 💪';

  @override
  String get reviewYourAnswers => 'Review your Answers';

  @override
  String get whichAnswersToReview => 'Which Answers you would review first';

  @override
  String wrongAnswers(Object count) {
    return 'Wrong Answers ($count)';
  }

  @override
  String correctAnswers(Object count) {
    return 'Correct Answers ($count)';
  }

  @override
  String get noQuizResultsAvailable => 'No quiz results available';

  @override
  String get completeAQuizFirst =>
      'Complete a quiz first to review your answers';

  @override
  String get noQuestionsToShow => 'No questions to show.';
}
