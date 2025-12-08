// // features/home/presentation/Screens/profile_screen.dart
// import 'package:depi_final_project/core/constants/appbar.dart';
// import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
// import 'package:depi_final_project/features/home/manager/history_cubit/history_state.dart';
// import 'package:flutter/material.dart';
// import 'package:depi_final_project/core/constants/app_constants.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:depi_final_project/l10n/app_localizations.dart';
// import 'package:depi_final_project/core/widgets/profile_components.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   static const String id = '/profile-screen';

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   User? user;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // fetch quizzes for the logged in user
//       context.read<HistoryCubit>().getQuizzesForStudent(user!.uid);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final widthRatio = screenWidth / 390.0;
//     final heightRatio = screenHeight / 844.0;

//     return Scaffold(
//       backgroundColor: const AppColors.primaryBackground,
//       appBar: CustomAppBar(Title: l10n.profile),
//       body: BlocBuilder<HistoryCubit, HistoryState>(
//         builder: (context, state) {
//           if (state is LoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ErrorState) {
//             return Center(
//               child: Text(state.error, style: const TextStyle(color: Colors.redAccent)),
//             );
//           }

//           final totalQuizzes = (state is LoadedState) ? state.totalQuizzes : 0;
//           final grouped = (state is LoadedState)
//               ? (state.groupedQuizzes as Map<String, List<dynamic>>)
//               : <String, List<dynamic>>{};
//           final totalSubjects = grouped.keys.length;

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 ProfileHeader(
//                   avatar: CircleAvatar(
//                     radius: 60 * widthRatio,
//                     backgroundImage: const AssetImage('assets/profile_image.jpg'),
//                   ),
//                   displayName: currentUser?.displayName ?? 'User',
//                   email: currentUser?.email ?? '',
//                   topSpacing: 60 * heightRatio,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 36 * widthRatio),
//                   child: Column(
//                     children: [
//                       StatCard(
//                         icon: Icons.list,
//                         label: 'All Quizzes Taken',
//                         value: totalQuizzes.toString(),
//                         width: widthRatio,
//                       ),
//                       SizedBox(height: 20 * heightRatio),
//                       StatCard(
//                         icon: Icons.book,
//                         label: 'Subjects',
//                         value: totalSubjects.toString(),
//                         width: widthRatio,
//                       ),
//                       SizedBox(height: 16 * heightRatio),
//                       StatCard(
//                         icon: Icons.star_border,
//                         label: 'Average Score',
//                         value: '${_computeAverage(grouped)}%',
//                         width: widthRatio,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   int _computeAverage(Map<String, List<dynamic>> grouped) {
//     final List<double> scores = [];

//     for (final list in grouped.values) {
//       for (final quiz in list) {
//         final pct = _extractPercentage(quiz);
//         if (pct != null) scores.add(pct);
//       }
//     }

//     if (scores.isEmpty) return 0;
//     final sum = scores.reduce((a, b) => a + b);
//     return (sum / scores.length).round();
//   }

//   double? _extractPercentage(dynamic quiz) {
//     try {
//       if (quiz == null) return null;

//       if (quiz is Map) {
//         final s = quiz['score'];
//         final t = quiz['total'];
//         if (s == null || t == null) return null;
//         final sn = (s is num) ? s.toDouble() : double.tryParse(s.toString());
//         final tn = (t is num) ? t.toDouble() : double.tryParse(t.toString());
//         if (sn == null || tn == null || tn == 0) return null;
//         return (sn / tn) * 100.0;
//       }

//       // try object properties
//       final s = quiz.score;
//       final t = quiz.total;
//       if (s == null || t == null) return null;
//       if (s is num && t is num && t != 0) {
//         return (s.toDouble() / t.toDouble()) * 100.0;
//       }
//     } catch (_) {
//       // ignore parsing errors
//     }
//     return null;
//   }
// }
