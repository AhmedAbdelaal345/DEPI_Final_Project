// teacher_profile_screen.dart
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/appbar.dart';
import 'package:depi_final_project/features/Teacher/cubit/teacherProfile/teacher_profile_cubit.dart';
import 'package:depi_final_project/features/Teacher/cubit/teacherProfile/teacher_profile_state.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/data/repositories/history_repository.dart';
import 'package:depi_final_project/core/services/cache_service.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:depi_final_project/features/profile/presentation/widgets/profile_header.dart';
import 'package:depi_final_project/features/profile/presentation/widgets/stat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/tabler.dart';

/// Teacher profile screen styled to match the student profile UI.
/// - Reuses ProfileHeader, ProUpgradeCard, StatCard widgets.
/// - Uses TeacherProfileCubit to stream/load teacher-specific stats.
/// - RefreshIndicator support and proper loading/error handling.
class TeacherProfileScreen extends StatelessWidget {
  final String? teacherName;

  const TeacherProfileScreen({super.key, this.teacherName});

  @override
  Widget build(BuildContext context) {
    final teacherId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return MultiBlocProvider(
      providers: [
        // Teacher cubit that loads teacher data (quizzes/subjects/avg)
        BlocProvider(
          create: (_) => TeacherProfileCubit()..loadTeacher(teacherId),
        ),
        // HistoryCubit is used by StatCard in the student profile.
        // For teacher view we still provide it (won't break if not used).
        BlocProvider(
            create: (_) =>
                HistoryCubit(HistoryRepository(cacheService: CacheService()))),
      ],
      child: _TeacherProfileContent(teacherName: teacherName),
    );
  }
}

class _TeacherProfileContent extends StatelessWidget {
  final String? teacherName;

  const _TeacherProfileContent({this.teacherName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(Title: l10n.profile), // matches student header
      body: BlocConsumer<TeacherProfileCubit, TeacherProfileState>(
        listener: (context, state) {
          if (state is TeacherProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is TeacherProfileLoaded) {
            // Optionally show a success snackbar if you have an update flow
          }
        },
        builder: (context, state) {
          if (state is TeacherProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5AC7C7)),
            );
          }

          if (state is TeacherProfileError) {
            // show retry UI same as student profile
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
                        context.read<TeacherProfileCubit>().loadTeacher(userId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TeacherProfileLoaded) {
            final user = FirebaseAuth.instance.currentUser;
            final profileName = teacherName ?? user?.displayName ?? 'Teacher';
            final profileEmail = user?.email ?? '';

            return RefreshIndicator(
              onRefresh: () async {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  await context.read<TeacherProfileCubit>().loadTeacher(userId);
                }
              },
              color: const Color(0xFF5AC7C7),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Reuse ProfileHeader for consistent look & animation
                    ProfileHeader(
                      userName: profileName,
                      userEmail: profileEmail,
                      profileImageUrl: AppConstants.brainLogo,
                      isPro: false, // if teachers can be pro, wire this from state
                    ),
                    const SizedBox(height: 24),

                    // Optionally show a Pro Upgrade card
                    // If you don't want this for teachers, remove this block.
                    // if (!isPro) ...[
                    //   ProUpgradeCard(onTap: () { /* open pro screen */ }),
                    //   const SizedBox(height: 24),
                    // ],

                    // Teacher-specific stats (mapped to same StatCard used by student)
                    _buildTeacherStats(context, state),
                  ],
                ),
              ),
            );
          }

          // fallback
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5AC7C7)),
          );
        },
      ),
    );
  }

Widget _buildTeacherStats(BuildContext context, TeacherProfileLoaded state) {
  return Column(
    children: [
      StatCard(
        icon: Tabler.list ,
        label: "All Quizzes Created",
        value: state.totalQuizzes.toString(),
      ),
      const SizedBox(height: 16),
      StatCard(
        icon: Tabler.books,
        label: "Subjects",
        value: state.totalSubjects.toString(),
      ),
      const SizedBox(height: 16),
      StatCard(
        icon: Tabler.star,
        label: "Avg. Questions per Quiz",
        value: state.averageQuestions.toStringAsFixed(1),
      ),
    ],
  );
}
}
