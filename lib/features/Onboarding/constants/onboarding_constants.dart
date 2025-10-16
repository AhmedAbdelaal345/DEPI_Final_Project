import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';

import 'package:depi_final_project/l10n/app_localizations.dart';

class OnboardingConstants {
  static List<OnboardPageModel> getPages(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return [
      OnboardPageModel(
        title: l10n.onboarding1Title,
        desc: l10n.onboarding1Desc,
        imageAsset: 'assets/images/onbording1.svg',
      ),
      OnboardPageModel(
        title: l10n.onboarding2Title,
        desc: l10n.onboarding2Desc,
        imageAsset: 'assets/images/onbording2.svg',
      ),
      OnboardPageModel(
        title: l10n.onboarding3Title,
        desc: l10n.onboarding3Desc,
        imageAsset: 'assets/images/onbording3.svg',
        isLast: true,
      ),
      // OnboardPageModel(
      //   title: l10n.onboarding4Title,
      //   desc: '',
      //   imageAsset: 'assets/images/onbording4.svg',
      //   isLast: true,
      // ),
    ];
  }
}