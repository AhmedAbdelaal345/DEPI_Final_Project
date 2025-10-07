import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/settings_tile.dart';
import '../widgets/custom_app_bar.dart';
import '../../../Onboarding/screens/onboarding_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: () => _handleNotifications(context),
          ),
          SettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Toggle dark/light theme',
            onTap: () => _handleTheme(context),
          ),
          SettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: () => _handleLanguage(context),
          ),
          SettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help and support',
            onTap: () => _handleHelp(context),
          ),
          SettingsTile(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App version and info',
            onTap: () => _handleAbout(context),
          ),
          const SizedBox(height: 20),
          // Logout Button
          SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  void _handleNotifications(BuildContext context) {
    // TODO: Implement notifications settings
  }

  void _handleTheme(BuildContext context) {
    // TODO: Implement theme settings
  }

  void _handleLanguage(BuildContext context) {
    // TODO: Implement language settings
  }

  void _handleHelp(BuildContext context) {
    // TODO: Implement help functionality
  }

  void _handleAbout(BuildContext context) {
    // TODO: Implement about page
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1C2B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FB3B7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              // Close dialog
              Navigator.pop(context);

              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF5AC7C7),
                  ),
                ),
              );

              try {
                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // Close loading dialog
                if (context.mounted) Navigator.pop(context);

                // Navigate to onboarding and clear all routes
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                    (route) => false,
                  );
                }

                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                // Close loading dialog
                if (context.mounted) Navigator.pop(context);

                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
