import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'QUIZLY'**
  String get appName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Mr. {name}'**
  String welcomeBack(Object name);

  /// No description provided for @createNewQuiz.
  ///
  /// In en, this message translates to:
  /// **'Create a new Quiz'**
  String get createNewQuiz;

  /// No description provided for @recentQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Recent\n Quizzes'**
  String get recentQuizzes;

  /// No description provided for @performanceReport.
  ///
  /// In en, this message translates to:
  /// **'Performance Report'**
  String get performanceReport;

  /// No description provided for @quizCreated.
  ///
  /// In en, this message translates to:
  /// **'Quiz Created'**
  String get quizCreated;

  /// No description provided for @quizCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Anyone who has this code can join and take the quiz.'**
  String get quizCreatedMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @quizCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Quiz code copied'**
  String get quizCodeCopied;

  /// No description provided for @enterQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Quiz title'**
  String get enterQuizTitle;

  /// No description provided for @durationInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (Min)'**
  String get durationInMinutes;

  /// No description provided for @thisFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This Field is required'**
  String get thisFieldRequired;

  /// No description provided for @pleaseEnterValidInteger.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid integer'**
  String get pleaseEnterValidInteger;

  /// No description provided for @durationMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Duration must be greater than 0'**
  String get durationMustBePositive;

  /// No description provided for @quizCode.
  ///
  /// In en, this message translates to:
  /// **'Quiz Code'**
  String get quizCode;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String questionNumber(Object number);

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter Question'**
  String get enterQuestion;

  /// No description provided for @enterOptionsAndSelectCorrect.
  ///
  /// In en, this message translates to:
  /// **'Enter options and select correct answer'**
  String get enterOptionsAndSelectCorrect;

  /// No description provided for @myQuizzes.
  ///
  /// In en, this message translates to:
  /// **'My Quizzes'**
  String get myQuizzes;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Questions Available'**
  String get noQuestionsAvailable;

  /// No description provided for @quizId.
  ///
  /// In en, this message translates to:
  /// **'Quiz ID: {id}'**
  String quizId(Object id);

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to QUIZLY !'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Test, and track your progress\nany time , any where'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'For Students'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter a code, take your quiz,\nand check your results instantly'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'For Teachers'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Create quizzes, auto-grade answers,\nand track student progress'**
  String get onboarding3Desc;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'Choose your role and start now!'**
  String get onboarding4Title;

  /// No description provided for @imAStudent.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Student'**
  String get imAStudent;

  /// No description provided for @imATeacher.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Teacher'**
  String get imATeacher;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome  ! please enter your details'**
  String get welcomeMessage;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Enter your email address and we\'ll send you a verification code.'**
  String get forgotPasswordMessage;

  /// No description provided for @rememberThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Remember this device'**
  String get rememberThisDevice;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **' OR Login with '**
  String get orLoginWith;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get createNewAccount;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @errorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get errorInvalidCredential;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided.'**
  String get errorWrongPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get errorInvalidEmail;

  /// No description provided for @errorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user account has been disabled.'**
  String get errorUserDisabled;

  /// No description provided for @errorNetworkRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection and try again.'**
  String get errorNetworkRequestFailed;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {message}'**
  String errorLoginFailed(Object message);

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful!'**
  String get loginSuccessful;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email'**
  String get resetLinkSent;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhoneNumber;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get enterYourFullName;

  /// No description provided for @orRegisterWith.
  ///
  /// In en, this message translates to:
  /// **' OR Register with '**
  String get orRegisterWith;

  /// No description provided for @enterYourSubject.
  ///
  /// In en, this message translates to:
  /// **'Enter your Subject'**
  String get enterYourSubject;

  /// No description provided for @pleaseEnterYourSubject.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Subject'**
  String get pleaseEnterYourSubject;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get errorEmailInUse;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccessful;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @enterQuizCode.
  ///
  /// In en, this message translates to:
  /// **'Enter quiz code'**
  String get enterQuizCode;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @pleaseEnterQuizCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a quiz code'**
  String get pleaseEnterQuizCode;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @allQuizzesTaken.
  ///
  /// In en, this message translates to:
  /// **'All Quizzes taken'**
  String get allQuizzesTaken;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// No description provided for @quizHistory.
  ///
  /// In en, this message translates to:
  /// **'Quiz History'**
  String get quizHistory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage your notifications'**
  String get manageNotifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark/light theme'**
  String get toggleTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeLanguage;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @getHelpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Get help and support'**
  String get getHelpAndSupport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersionInfo.
  ///
  /// In en, this message translates to:
  /// **'App version and info'**
  String get appVersionInfo;

  /// No description provided for @teacherScreen.
  ///
  /// In en, this message translates to:
  /// **'Teacher Screen'**
  String get teacherScreen;

  /// No description provided for @quizNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quiz not found'**
  String get quizNotFound;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @timeLimit.
  ///
  /// In en, this message translates to:
  /// **'Time limit'**
  String get timeLimit;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'{time} Mins'**
  String minutesUnit(Object time);

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @instruction1.
  ///
  /// In en, this message translates to:
  /// **'Ensure you have a stable internet connection.'**
  String get instruction1;

  /// No description provided for @instruction2.
  ///
  /// In en, this message translates to:
  /// **'The quiz will automatically submit when the time runs out.'**
  String get instruction2;

  /// No description provided for @instruction3.
  ///
  /// In en, this message translates to:
  /// **'You cannot pause the quiz once started.'**
  String get instruction3;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Click To Start Your Journey'**
  String get startYourJourney;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @submitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get submitQuiz;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed!'**
  String get quizCompleted;

  /// No description provided for @yourPerformanceSummary.
  ///
  /// In en, this message translates to:
  /// **'Your Performance Summary'**
  String get yourPerformanceSummary;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// No description provided for @excellentWork.
  ///
  /// In en, this message translates to:
  /// **'Excellent work! 🎉'**
  String get excellentWork;

  /// No description provided for @goodJob.
  ///
  /// In en, this message translates to:
  /// **'Good job! 👍'**
  String get goodJob;

  /// No description provided for @notBadKeepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Not bad, keep practicing! 📚'**
  String get notBadKeepPracticing;

  /// No description provided for @keepStudying.
  ///
  /// In en, this message translates to:
  /// **'Keep studying and try again! 💪'**
  String get keepStudying;

  /// No description provided for @reviewYourAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review your Answers'**
  String get reviewYourAnswers;

  /// No description provided for @whichAnswersToReview.
  ///
  /// In en, this message translates to:
  /// **'Which Answers you would review first'**
  String get whichAnswersToReview;

  /// No description provided for @wrongAnswers.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answers ({count})'**
  String wrongAnswers(Object count);

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers ({count})'**
  String correctAnswers(Object count);

  /// No description provided for @noQuizResultsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No quiz results available'**
  String get noQuizResultsAvailable;

  /// No description provided for @completeAQuizFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete a quiz first to review your answers'**
  String get completeAQuizFirst;

  /// No description provided for @noQuestionsToShow.
  ///
  /// In en, this message translates to:
  /// **'No questions to show.'**
  String get noQuestionsToShow;

  /// No description provided for @featureWillGetSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature Will Get Soon'**
  String get featureWillGetSoon;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logOutDetails.
  ///
  /// In en, this message translates to:
  /// **'If you need To Log out, plesse press here'**
  String get logOutDetails;

  /// No description provided for @logoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccessful;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Delete Your Account'**
  String get deleteAccountDetails;

  /// No description provided for @enterTeacherCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Teacher Code'**
  String get enterTeacherCode;

  /// No description provided for @phase.
  ///
  /// In en, this message translates to:
  /// **'Success is the sum of small efforts repeated day in and day out.'**
  String get phase;

  /// No description provided for @teacherProfile.
  ///
  /// In en, this message translates to:
  /// **'Teacher Profile'**
  String get teacherProfile;

  /// No description provided for @noQuizHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No quiz history yet'**
  String get noQuizHistoryYet;

  /// No description provided for @startTakingQuizzesToSeeProgress.
  ///
  /// In en, this message translates to:
  /// **'Start taking quizzes to see your progress!'**
  String get startTakingQuizzesToSeeProgress;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @quizzesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Quizzes'**
  String quizzesCount(Object count);

  /// No description provided for @noQuizzesYetForSubject.
  ///
  /// In en, this message translates to:
  /// **'No quizzes yet for this subject'**
  String get noQuizzesYetForSubject;

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on'**
  String get completedOn;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @quizDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quiz details not found'**
  String get quizDetailsNotFound;

  /// No description provided for @errorLoadingQuizDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading quiz details'**
  String get errorLoadingQuizDetails;

  /// No description provided for @errorDeletingQuizResult.
  ///
  /// In en, this message translates to:
  /// **'Error deleting quiz result'**
  String get errorDeletingQuizResult;

  /// No description provided for @chatWithTeacher.
  ///
  /// In en, this message translates to:
  /// **'Chat with Teacher'**
  String get chatWithTeacher;

  /// No description provided for @unableToOpenChatMissingQuizId.
  ///
  /// In en, this message translates to:
  /// **'Unable to open chat: Missing Quiz ID'**
  String get unableToOpenChatMissingQuizId;

  /// No description provided for @unableToOpenChatMissingTeacherId.
  ///
  /// In en, this message translates to:
  /// **'Unable to open chat: Missing Teacher ID'**
  String get unableToOpenChatMissingTeacherId;

  /// No description provided for @resolveQuiz.
  ///
  /// In en, this message translates to:
  /// **'Resolve Quiz'**
  String get resolveQuiz;

  /// No description provided for @resolveQuizConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to resolve this quiz?'**
  String get resolveQuizConfirmation;

  /// No description provided for @yesResolve.
  ///
  /// In en, this message translates to:
  /// **'Yes, Resolve'**
  String get yesResolve;

  /// No description provided for @errorLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Error logging out'**
  String get errorLoggingOut;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @pleaseLoginAgainToDelete.
  ///
  /// In en, this message translates to:
  /// **'Please login again to delete your account'**
  String get pleaseLoginAgainToDelete;

  /// No description provided for @errorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account'**
  String get errorDeletingAccount;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
