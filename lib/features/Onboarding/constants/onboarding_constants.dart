import '../models/onboard_page_model.dart';

class OnboardingConstants {
  static final List<OnboardPageModel> pages = [
    OnboardPageModel(
      title: 'Welcome to QUIZY !',
      desc: 'Test, and track your progress\nany time , any where',
      imageAsset: 'assets/images/onbording1.svg',
    ),
    OnboardPageModel(
      title: 'For Students',
      desc: 'Enter a code, take your quiz,\nand check your results instantly',
      imageAsset: 'assets/images/onbording2.svg',
    ),
    OnboardPageModel(
      title: 'For Teachers',
      desc: 'Create quizzes, auto-grade answers,\nand track student progress',
      imageAsset: 'assets/images/onbording3.svg',
    ),
    OnboardPageModel(
      title: 'Choose your role and start now!',
      desc: '',
      imageAsset: 'assets/images/onbording4.svg',
      isLast: true,
    ),
  ];
}
