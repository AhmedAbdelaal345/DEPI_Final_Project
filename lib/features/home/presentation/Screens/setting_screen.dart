import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/locale_cubit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(l10n.settings, style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsTile(
            icon: Icons.notifications,
            title: l10n.notifications,
            subtitle: l10n.manageNotifications,
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

          _buildSettingsTile(
            icon: Icons.help,
            title: l10n.helpAndSupport,
            subtitle: l10n.getHelpAndSupport,
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
            icon: Icons.info,
            title: l10n.about,
            subtitle: l10n.appVersionInfo,
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
            icon: Icons.logout,
            title: l10n.logOut,
            subtitle: l10n.logOutDetails,
            onTap: () async {
              Navigator.pushNamed(context, LoginScreen.id);
              await FirebaseAuth.instance.signOut();
            },
          ),
          _buildSettingsTile(
            icon: Icons.person_add_disabled_outlined,
            title: l10n.deleteAccount,
            subtitle: l10n.deleteAccountDetails,
            onTap: () {
              FirebaseAuth.instance.currentUser!.delete();
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
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
