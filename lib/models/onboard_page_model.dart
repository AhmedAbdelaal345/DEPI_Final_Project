class OnboardPageModel {
  final String title;
  final String desc;
  final String imageAsset;
  final bool isLast;

  OnboardPageModel({
    required this.title,
    required this.desc,
    required this.imageAsset,
    this.isLast = false,
  });
}
