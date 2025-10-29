// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'كويزلي';

  @override
  String welcomeBack(Object name) {
    return 'أهلاً بعودتك! أ. $name';
  }

  @override
  String get createNewQuiz => 'إنشاء اختبار جديد';

  @override
  String get recentQuizzes => 'أحدث\nالاختبارات';

  @override
  String get performanceReport => 'تقرير الأداء';

  @override
  String get quizCreated => 'تم إنشاء الاختبار';

  @override
  String get quizCreatedMessage =>
      'يمكن لأي شخص لديه هذا الرمز الانضمام وإجراء الاختبار.';

  @override
  String get ok => 'حسناً';

  @override
  String get quizCodeCopied => 'تم نسخ رمز الاختبار';

  @override
  String get enterQuizTitle => 'أدخل عنوان الاختبار';

  @override
  String get durationInMinutes => 'المدة (بالدقائق)';

  @override
  String get thisFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get quizCode => 'رمز الاختبار';

  @override
  String get create => 'إنشاء';

  @override
  String questionNumber(Object number) {
    return 'السؤال رقم $number';
  }

  @override
  String get addQuestion => 'أضف سؤال';

  @override
  String get enterQuestion => 'أدخل السؤال';

  @override
  String get enterOptionsAndSelectCorrect =>
      'أدخل الخيارات واختر الإجابة الصحيحة';

  @override
  String get myQuizzes => 'اختباراتي';

  @override
  String get noQuestionsAvailable => 'لا توجد أسئلة متاحة';

  @override
  String quizId(Object id) {
    return 'رمز الاختبار: $id';
  }

  @override
  String get onboarding1Title => 'أهلاً بك في كويزلي!';

  @override
  String get onboarding1Desc => 'اختبر، وتتبع تقدمك\nفي أي وقت، ومن أي مكان';

  @override
  String get onboarding2Title => 'للطلاب';

  @override
  String get onboarding2Desc =>
      'أدخل الرمز، خُض اختبارك،\nواطلع على نتيجتك فوراً';

  @override
  String get onboarding3Title => 'للمعلمين';

  @override
  String get onboarding3Desc =>
      'أنشئ الاختبارات، صحح الإجابات تلقائياً،\nوتتبع تقدم طلابك';

  @override
  String get onboarding4Title => 'اختر دورك وابدأ الآن!';

  @override
  String get imAStudent => 'أنا طالب';

  @override
  String get imATeacher => 'أنا معلم';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get welcomeMessage => 'أهلاً بك! يرجى إدخال بياناتك';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordMessage =>
      'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رمز التحقق.';

  @override
  String get rememberThisDevice => 'تذكر هذا الجهاز';

  @override
  String get orLoginWith => ' أو سجل الدخول باستخدام ';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟ ';

  @override
  String get createNewAccount => 'أنشئ حساباً جديداً';

  @override
  String get pleaseEnterYourEmail => 'من فضلك أدخل بريدك الإلكتروني';

  @override
  String get pleaseEnterPassword => 'من فضلك أدخل كلمة المرور';

  @override
  String get enterValidEmail => 'من فضلك أدخل بريد إلكتروني صالح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get errorInvalidCredential =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorUserNotFound => 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني.';

  @override
  String get errorWrongPassword => 'كلمة المرور التي أدخلتها غير صحيحة.';

  @override
  String get errorInvalidEmail => 'صيغة البريد الإلكتروني غير صالحة.';

  @override
  String get errorUserDisabled => 'تم تعطيل حساب المستخدم هذا.';

  @override
  String get errorNetworkRequestFailed =>
      'خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String errorLoginFailed(Object message) {
    return 'فشل تسجيل الدخول: $message';
  }

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح!';

  @override
  String get sendCode => 'أرسل الرمز';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get resetLinkSent =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني';

  @override
  String get register => 'تسجيل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get confirmYourPassword => 'تأكيد كلمة المرور';

  @override
  String get pleaseConfirmPassword => 'من فضلك أكّد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get enterYourPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get pleaseEnterPhoneNumber => 'من فضلك أدخل رقم هاتفك';

  @override
  String get enterValidPhoneNumber => 'من فضلك أدخل رقم هاتف صحيح';

  @override
  String get alreadyHaveAnAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get enterYourFullName => 'من فضلك أدخل اسمك الكامل';

  @override
  String get orRegisterWith => ' أو سجل باستخدام ';

  @override
  String get enterYourSubject => 'أدخل المادة الدراسية';

  @override
  String get pleaseEnterYourSubject => 'من فضلك أدخل المادة الدراسية';

  @override
  String get errorWeakPassword => 'كلمة المرور التي أدخلتها ضعيفة جدًا.';

  @override
  String get errorEmailInUse => 'هذا البريد الإلكتروني مسجل بحساب آخر بالفعل.';

  @override
  String get registrationSuccessful => 'تم التسجيل بنجاح!';

  @override
  String get home => 'الرئيسية';

  @override
  String get enterQuizCode => 'أدخل رمز الاختبار';

  @override
  String get join => 'انضمام';

  @override
  String get pleaseEnterQuizCode => 'من فضلك أدخل رمز الاختبار';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get allQuizzesTaken => 'كل الاختبارات التي تم إجراؤها';

  @override
  String get subjects => 'المواد الدراسية';

  @override
  String get averageScore => 'متوسط الدرجات';

  @override
  String get quizHistory => 'سجل الاختبارات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageNotifications => 'إدارة الإشعارات الخاصة بك';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get toggleTheme => 'تبديل المظهر الداكن/الفاتح';

  @override
  String get language => 'اللغة';

  @override
  String get changeLanguage => 'تغيير لغة التطبيق';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get getHelpAndSupport => 'احصل على المساعدة والدعم';

  @override
  String get about => 'حول التطبيق';

  @override
  String get appVersionInfo => 'إصدار التطبيق ومعلومات عنه';

  @override
  String get teacherScreen => 'شاشة المعلم';

  @override
  String get quizNotFound => 'لم يتم العثور على الاختبار';

  @override
  String get questions => 'الأسئلة';

  @override
  String get timeLimit => 'الوقت المحدد';

  @override
  String minutesUnit(Object time) {
    return '$time دقيقة';
  }

  @override
  String get creator => 'المنشئ';

  @override
  String get instructions => 'التعليمات';

  @override
  String get instruction1 => 'تأكد من وجود اتصال مستقر بالإنترنت.';

  @override
  String get instruction2 => 'سيتم إرسال الاختبار تلقائياً عند انتهاء الوقت.';

  @override
  String get instruction3 => 'لا يمكنك إيقاف الاختبار مؤقتاً بعد البدء.';

  @override
  String get startYourJourney => 'اضغط لبدء رحلتك';

  @override
  String get backToHome => 'العودة إلى الرئيسية';

  @override
  String get submitQuiz => 'إرسال الاختبار';

  @override
  String get quizCompleted => 'اكتمل الاختبار!';

  @override
  String get yourPerformanceSummary => 'ملخص أدائك';

  @override
  String get score => 'الدرجة';

  @override
  String get accuracy => 'الدقة';

  @override
  String get correct => 'صحيح';

  @override
  String get wrong => 'خاطئ';

  @override
  String get reviewAnswers => 'مراجعة الإجابات';

  @override
  String get excellentWork => 'عمل ممتاز! 🎉';

  @override
  String get goodJob => 'أحسنت! 👍';

  @override
  String get notBadKeepPracticing => 'ليس سيئاً، استمر في الممارسة! 📚';

  @override
  String get keepStudying => 'استمر في المذاكرة وحاول مجدداً! 💪';

  @override
  String get reviewYourAnswers => 'راجع إجاباتك';

  @override
  String get whichAnswersToReview => 'أي الإجابات تود مراجعتها أولاً';

  @override
  String wrongAnswers(Object count) {
    return 'الإجابات الخاطئة ($count)';
  }

  @override
  String correctAnswers(Object count) {
    return 'الإجابات الصحيحة ($count)';
  }

  @override
  String get noQuizResultsAvailable => 'لا توجد نتائج اختبار متاحة';

  @override
  String get completeAQuizFirst => 'أكمل اختباراً أولاً لمراجعة إجاباتك';

  @override
  String get noQuestionsToShow => 'لا توجد أسئلة لعرضها.';

  @override
  String get featureWillGetSoon => 'سيتم توفير الخاصية قريباً';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get logOutDetails => 'اضغط هنا لتسجيل الخروج';

  @override
  String get logoutSuccessful => 'تم تسجيل الخروج بنجاح';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountDetails => 'حذف حسابك';

  @override
  String get enterTeacherCode => 'ادخل كود المعلم ';

  @override
  String get phase =>
      'النجاح هو مجموع الجهود الصغيرة التي تتكرر يوماً بعد يوم.';
}
