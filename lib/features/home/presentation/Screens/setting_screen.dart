import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/core/services/auth_service.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:depi_final_project/features/home/cubit/locale_cubit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(Title: l10n.settings),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // _buildSettingsTile(
          //   icon: Icons.notifications,
          //   title: l10n.notifications,
          //   subtitle: l10n.manageNotifications,
          //   onTap: () {
          //     Fluttertoast.showToast(
          //       msg: l10n.featureWillGetSoon,
          //       backgroundColor: AppColors.white,
          //       textColor: AppColors.hint,
          //       fontSize: 16,
          //     );
          //   },
          // ),
          _buildSettingsTile(
            icon: Icons.dark_mode,
            title: l10n.darkMode,
            subtitle: l10n.toggleTheme,
            onTap: () {
              Fluttertoast.showToast(
                msg: l10n.featureWillGetSoon,
                backgroundColor: AppColors.white,
                textColor: AppColors.hint,
                fontSize: 16,
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: l10n.language,
            subtitle: l10n.changeLanguage,
            onTap: () {
              _showLanguageDialog(context);
            },
          ),

          // _buildSettingsTile(
          //   icon: Icons.help,
          //   title: l10n.helpAndSupport,
          //   subtitle: l10n.getHelpAndSupport,
          //   onTap: () {
          //     Fluttertoast.showToast(
          //       msg: l10n.featureWillGetSoon,
          //       backgroundColor: AppColors.white,
          //       textColor: AppColors.hint,
          //       fontSize: 16,
          //     );
          //   },
          // ),
          // _buildSettingsTile(
          //   icon: Icons.info,
          //   title: l10n.about,
          //   subtitle: l10n.appVersionInfo,
          //   onTap: () {
          //     Fluttertoast.showToast(
          //       msg: l10n.featureWillGetSoon,
          //       backgroundColor: AppColors.white,
          //       textColor: AppColors.hint,
          //       fontSize: 16,
          //     );
          //   },
          // ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: l10n.logOut,
            subtitle: l10n.logOutDetails,
            onTap: () async {
              // Show confirmation dialog
              final shouldLogout = await _showLogoutDialog(context);
              if (shouldLogout == true) {
                try {
                  // Use AuthService to clear login state
                  await AuthService().signOut();

                  // Show success message
                  Fluttertoast.showToast(
                    msg: l10n.logoutSuccessful,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16,
                  );

                  // Navigate to login screen
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Error logging out: $e',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16,
                  );
                }
              }
            },
          ),
          _buildSettingsTile(
            icon: Icons.person_add_disabled_outlined,
            title: l10n.deleteAccount,
            subtitle: l10n.deleteAccountDetails,
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2F48),
          title: Text(
            l10n.logOut,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.logoutConfirmation,
            style: TextStyle(color: Colors.grey.shade400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5AC7C7),
              ),
              child: Text(
                l10n.confirm,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2F48),
          title: const Text(
            'Choose Language',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage(
                    const Locale('en'),
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'العربية',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage(
                    const Locale('ar'),
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2F48),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF5AC7C7), size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C2F48),
        title: Text(
          l10n.deleteAccount,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _deleteUserAccount(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteUserAccount(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Clear login state using AuthService
    await AuthService().clearLoginState();

    // حذف بيانات المستخدم من Firestore (إذا كان موجود)
    // await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

    // حذف حساب Authentication
    await user.delete();

    // الانتقال لشاشة تسجيل الدخول
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }

    Fluttertoast.showToast(
      msg: 'Account deleted successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      Fluttertoast.showToast(
        msg: 'Please login again to delete your account',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error deleting account: ${e.message}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: 'Error: $e',
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
