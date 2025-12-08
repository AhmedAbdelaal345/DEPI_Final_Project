import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/widgets/app_drawer.dart';
import 'package:depi_final_project/features/Quiz/presentation/Screens/before_quiz_screen.dart';
import 'package:depi_final_project/features/chat/cubit/chat_cubit.dart';
import 'package:depi_final_project/features/chat/data/repositories/chat_repository.dart';
import 'package:depi_final_project/features/chat/presentation/screens/chat_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/student_review_selection.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import '../widgets/detail_item.dart';

class QuizDetailsScreen extends StatefulWidget {
  final String subject;
  final Map<String, String> quizData;

  const QuizDetailsScreen({
    super.key,
    required this.subject,
    required this.quizData,
  });

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  Map<String, dynamic>? studentQuizDetails;
  Map<String, dynamic>? quizMetadata;
  Map<String, dynamic>? teacherDetails;
  bool isLoading = true;
  String? errorMessage;
  
  @override
  void initState() {
    super.initState();
    _fetchAllQuizDetails();
  }

  Future<void> _fetchAllQuizDetails() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        setState(() {
          errorMessage = l10n.userNotAuthenticated; // Using localization
          isLoading = false;
        });
        return;
      }

      final quizId = widget.quizData[AppConstants.id];

      final studentDoc = await FirebaseFirestore.instance
          .collection(AppConstants.studentCollection)
          .doc(userId)
          .collection(AppConstants.quizzessmall)
          .doc(quizId)
          .get();
          
      final quizDoc = await FirebaseFirestore.instance
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .get();

      Map<String, dynamic>? teacherData;
      if (quizDoc.exists) {
        final quizData = quizDoc.data();
        final teacherId = quizData?['teacherId'];

        if (teacherId != null && teacherId.toString().isNotEmpty) {
          final teacherDoc = await FirebaseFirestore.instance
              .collection(AppConstants.teacherCollection)
              .doc(teacherId)
              .get();

          if (teacherDoc.exists) {
            teacherData = teacherDoc.data();
          }
        }
      }

      if (studentDoc.exists) {
        setState(() {
          studentQuizDetails = studentDoc.data();
          quizMetadata = quizDoc.exists ? quizDoc.data() : null;
          teacherDetails = teacherData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = l10n.quizDetailsNotFound; // Using localization
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '${l10n.errorLoadingQuizDetails}: $e'; // Using localization
        isLoading = false;
      });
    }
  }

  Future<void> _deleteQuizResult() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final quizId = widget.quizData[AppConstants.id];

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
      );

      await FirebaseFirestore.instance
          .collection(AppConstants.studentCollection)
          .doc(userId)
          .collection(AppConstants.quizzessmall)
          .doc(quizId)
          .delete();

      if (!mounted) return;
      Navigator.pop(context);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BeforeQuizScreen(quizId: quizId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorDeletingQuizResult}: $e'), // Using localization
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      endDrawer: AppDrawer(
        onItemTapped: (index) {
          Navigator.pop(context);
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperPage(initialIndex: 0),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperPage(initialIndex: 1),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WrapperPage(initialIndex: 3),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${widget.quizData["title"]} Quiz",
            style: GoogleFonts.irishGrover(
              fontSize: AppFontSizes.xxl,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryTeal),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 60,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          _fetchAllQuizDetails();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                        ),
                        child: Text(l10n.retry), // TODO: Add "retry": "Retry" to .arb
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      DetailItem(
                        icon: IconParkOutline.list,
                        label: l10n.questions,
                        value: "${_getQuestionCount()}",
                      ),
                      SizedBox(height: AppSpacing.md),
                      DetailItem(
                        icon: Lucide.alarm_clock,
                        label: l10n.timeLimit,
                        value: _getTimeLimit(),
                      ),
                      SizedBox(height: AppSpacing.md),
                      DetailItem(
                        icon: Mdi.account_tie_outline,
                        label: l10n.creator,
                        value: _getCreator(),
                      ),
                      SizedBox(height: AppSpacing.md),
                      DetailItem(
                        icon: Mdi.calendar_month,
                        label: l10n.completedOn, // TODO: Add "completedOn": "Completed on" to .arb
                        value: _formatDate(studentQuizDetails?['createdAt']),
                      ),
                      SizedBox(height: AppSpacing.md),
                      DetailItem(
                        icon: Mdi.star_circle_outline,
                        label: l10n.score,
                        value: _calculateScore(),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Chat button
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              color: AppColors.white,
                            ),
                            label: Text(
                              l10n.chatWithTeacher, // TODO: Add "chatWithTeacher": "Chat with Teacher" to .arb
                              style: TextStyle(
                                fontSize: AppFontSizes.md,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.mediumBorderRadius,
                              ),
                            ),
                            onPressed: () async {
                              final String? quizId = widget.quizData[AppConstants.id];
                              String? teacherId;

                              if (quizMetadata != null &&
                                  quizMetadata!['teacherId'] != null) {
                                teacherId = quizMetadata!['teacherId']?.toString();
                              }

                              teacherId ??= widget.quizData[AppConstants.teacherId];

                              final String studentUid =
                                  FirebaseAuth.instance.currentUser!.uid;

                              if (quizId == null || quizId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.unableToOpenChatMissingQuizId, // TODO: Add to .arb
                                    ),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              if (teacherId == null || teacherId.isEmpty) {
                                if (!mounted) return;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryTeal,
                                    ),
                                  ),
                                );

                                try {
                                  final quizDoc = await FirebaseFirestore.instance
                                      .collection('Quizzes')
                                      .doc(quizId)
                                      .get();
                                  if (quizDoc.exists) {
                                    final data = quizDoc.data();
                                    teacherId = data?['teacherId']?.toString();
                                  }
                                } catch (e) {
                                  debugPrint(
                                    'Failed to fetch quiz doc for teacherId: $e',
                                  );
                                } finally {
                                  if (mounted) Navigator.pop(context);
                                }
                              }

                              if (teacherId == null || teacherId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.unableToOpenChatMissingTeacherId, // TODO: Add to .arb
                                    ),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (_) => ChatCubit(ChatRepository()),
                                    child: ChatScreen(
                                      studentId: studentUid,
                                      teacherId: teacherId!,
                                      quizId: quizId,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: AppSpacing.sm),

                          // Resolve Quiz button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.mediumBorderRadius,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.primaryBackground,
                                    title: Text(
                                      l10n.resolveQuiz, // TODO: Add "resolveQuiz": "Resolve Quiz" to .arb
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                    content: Text(
                                      l10n.resolveQuizConfirmation, // TODO: Add to .arb
                                      style: TextStyle(color: AppColors.white54),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dialogContext),
                                        child: Text(
                                          l10n.cancel,
                                          style: TextStyle(color: AppColors.white54),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryTeal,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          _deleteQuizResult();
                                        },
                                        child: Text(
                                          l10n.yesResolve, // TODO: Add "yesResolve": "Yes, Resolve" to .arb
                                          style: TextStyle(color: AppColors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              l10n.resolveQuiz,
                              style: TextStyle(
                                fontSize: AppFontSizes.md,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),

                          // View Answers button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.mediumBorderRadius,
                              ),
                            ),
                            onPressed: () {
                              String studentUid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StudentReviewSelectionScreen(
                                    quizId: widget.quizData[AppConstants.id]!,
                                    studentId: studentUid,
                                    quizTitle: widget.subject,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              l10n.reviewAnswers,
                              style: TextStyle(
                                fontSize: AppFontSizes.md,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  int _getQuestionCount() {
    if (studentQuizDetails != null && studentQuizDetails!['total'] != null) {
      return studentQuizDetails!['total'];
    }

    if (quizMetadata != null) {
      if (quizMetadata!['question_count'] != null) {
        return quizMetadata!['question_count'];
      }
      if (quizMetadata!['questions'] != null &&
          quizMetadata!['questions'] is List) {
        return (quizMetadata!['questions'] as List).length;
      }
    }

    return 0;
  }

  String _getTimeLimit() {
    if (quizMetadata != null && quizMetadata!['duration'] != null) {
      final duration = quizMetadata!['duration'];
      if (duration is String) {
        final durationInt = int.tryParse(duration);
        if (durationInt != null) {
          return '$durationInt Mins';
        }
        return duration.contains('Min') ? duration : '$duration Mins';
      } else if (duration is int) {
        return '$duration Mins';
      }
    }
    return '30 Mins';
  }

  String _getCreator() {
    if (teacherDetails != null && teacherDetails!['fullName'] != null) {
      final fullName = teacherDetails!['fullName'];
      if (fullName is String && fullName.isNotEmpty) {
        return fullName;
      }
    }

    if (quizMetadata != null && quizMetadata!['teacherId'] != null) {
      return quizMetadata!['teacherId'].toString();
    }

    return 'Unknown';
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return widget.quizData["date"] ?? 'Unknown';

    try {
      DateTime date;
      if (timestamp is Timestamp) {
        date = timestamp.toDate();
      } else if (timestamp is DateTime) {
        date = timestamp;
      } else {
        return widget.quizData["date"] ?? 'Unknown';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return widget.quizData["date"] ?? 'Unknown';
    }
  }

  String _calculateScore() {
    if (studentQuizDetails == null) return widget.quizData["score"] ?? 'N/A';

    final score = (studentQuizDetails!['score'] ?? 0).toDouble();
    final total = studentQuizDetails!['total'] ?? 1;

    if (total == 0) return '0%';

    final percentage = (score / total * 100).toStringAsFixed(0);
    return '$percentage%';
  }
}
