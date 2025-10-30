import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppConstants.brainLogo,
            height: height * 0.12,
            width: width * 0.5,
          ),
          Center(
            child: Text(
              "A new version of the app is available. Please update to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: "Judson",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
