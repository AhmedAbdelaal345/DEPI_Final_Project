// features/home/presentation/Screens/setting_screen.dart
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/core/services/auth_service.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/features/home/cubit/locale_cubit.dart';
import 'package:depi_final_project/core/widgets/ui_components.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const String id = '/setting-screen';
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(Title: l10n.settings),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          _buildSettingsTile(
            icon: Icons.dark_mode,
            title: l10n.darkMode,
            subtitle: l10n.toggleTheme,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.featureWillGetSoon)),
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
            icon: Icons.logout,
            title: l10n.logOut,
            subtitle: l10n.logOutDetails,
            onTap: () async {
              final shouldLogout = await _showLogoutDialog(context);
              if (shouldLogout == true) {
                try {
                  await AuthService().signOut();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.logoutSuccessful),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.errorLoggingOut}: $e'), // TODO: Add to .arb
                      backgroundColor: AppColors.error,
                    ),
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
    final l10n = AppLocalizations.of(context)!;
    
    return AppDialog.show<bool>(
      context,
      title: l10n.logOut,
      content: Text(
        l10n.logoutConfirmation,
        style: TextStyle(color: AppColors.white54),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal,
          ),
          child: Text(
            l10n.confirm,
            style: TextStyle(color: AppColors.white),
          ),
        )
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    AppDialog.show<void>(
      context,
      title: l10n.chooseLanguage, // TODO: Add to .arb
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'English',
              style: TextStyle(color: AppColors.white),
            ),
            onTap: () {
              context.read<LocaleCubit>().changeLanguage(const Locale('en'));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(
              'العربية',
              style: TextStyle(color: AppColors.white),
            ),
            onTap: () {
              context.read<LocaleCubit>().changeLanguage(const Locale('ar'));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppBorderRadius.mediumBorderRadius,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primaryTeal,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFontSizes.md,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.white54,
            fontSize: AppFontSizes.sm,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          l10n.deleteAccount,
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          l10n.deleteAccountConfirmation, // TODO: Add to .arb
          style: TextStyle(color: AppColors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _deleteUserAccount(context);
            },
            child: Text(
              l10n.delete, // TODO: Add to .arb
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteUserAccount(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await AuthService().clearLoginState();
    await user.delete();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.accountDeletedSuccessfully), // TODO: Add to .arb
          backgroundColor: AppColors.success,
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseLoginAgainToDelete), // TODO: Add to .arb
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorDeletingAccount}: ${e.message}'), // TODO: Add to .arb
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: $e'), // TODO: Add to .arb
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
