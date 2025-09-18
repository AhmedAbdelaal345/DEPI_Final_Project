import 'package:flutter/material.dart';
import '../widgets/title_bar.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/curved_bottom_nav.dart';
import '../widgets/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const CurvedBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sx(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TitleBar(title: 'Home'),
              SizedBox(height: sy(context, 48)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InputField(hint: 'Enter quiz code'),
                ),
              ),
              SizedBox(height: sy(context, 18)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PrimaryButton(
                  label: 'Join',
                  onTap: () {
                    Navigator.pushNamed(context, '/details');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
