// features/profile/presentation/screens/profile_screen_with_firebase.dart
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import '../widgets/profile_header.dart';
import '../widgets/pro_upgrade_card.dart';
import '../widgets/stat_card.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import '../../data/repositories/profile_repository.dart';
import 'pro_features_screen.dart';

class ProfileScreenWithFirebase extends StatelessWidget {
  const ProfileScreenWithFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileScreenContent();
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF000920),
      appBar: CustomAppBar(Title: l10n.profile),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProSubscriptionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5AC7C7)),
            );
          }

          if (state is ProfileError && state.message.contains('not found')) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        context.read<ProfileCubit>().refreshProfile(userId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.userProfile;

            return RefreshIndicator(
              onRefresh: () async {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  await context.read<ProfileCubit>().refreshProfile(userId);
                }
              },
              color: const Color(0xFF5AC7C7),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Header with Animation
                    ProfileHeader(
                      userName: profile.fullName,
                      userEmail: profile.email,
                      profileImageUrl:
                          profile.profileImageUrl ??
                          "assets/images/brain_logo.png",
                      isPro: profile.isProActive,
                    ),
                    const SizedBox(height: 24),

                    // Pro Upgrade Card (only if not pro)
                    if (!profile.isProActive) ...[
                      ProUpgradeCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider.value(
                                    value: context.read<ProfileCubit>(),
                                    child: const ProFeaturesScreen(),
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Pro Status Info (if Pro)
                    if (profile.isProActive &&
                        profile.proExpiryDate != null) ...[
                      _buildProStatusCard(profile.proExpiryDate!),
                      const SizedBox(height: 24),
                    ],

                    // Statistics Cards
                    _buildStatisticsSection(context),
                  ],
                ),
              ),
            );
          }

          // Default loading state
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5AC7C7)),
          );
        },
      ),
    );
  }

  Widget _buildProStatusCard(DateTime expiryDate) {
    final daysLeft = expiryDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C7A7E), Color(0xFF4FB3B7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5AC7C7), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pro Member",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$daysLeft days remaining",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    List<int> allScores = [];
    for (var list in context.read<HistoryCubit>().groupedQuizzes.values) {
      for (var quiz in list) {
        if (quiz.score != null && quiz.total != null) {
          allScores.add(((quiz.score / quiz.total) * 100).round());
        }
      }
    }
    int averageScore =
        allScores.isEmpty
            ? 0
            : (allScores.reduce((a, b) => a + b) / allScores.length).round();

    return Column(
      children: [
        StatCard(
          icon: IconParkOutline.list,
          label: "All Quizzes taken",
          value: context.read<HistoryCubit>().allQuizzes.length.toString(),
        ),
        const SizedBox(height: 16),
        StatCard(
          icon: Tabler.books,
          label: "Subjects",
          value:
              context
                  .read<HistoryCubit>()
                  .groupedQuizzes
                  .keys
                  .length
                  .toString(),
        ),
        const SizedBox(height: 16),
        StatCard(
          icon: Tabler.star,
          label: "Average Score",
          value: "${averageScore}%",
        ),
      ],
    );
  }
}
