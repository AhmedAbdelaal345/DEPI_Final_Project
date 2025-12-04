import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Quiz/presentation/Screens/before_quiz_screen.dart';
import 'package:depi_final_project/features/chat/cubit/chat_cubit.dart';
import 'package:depi_final_project/features/chat/data/repositories/chat_repository.dart';
import 'package:depi_final_project/features/chat/presentation/screens/chat_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/profile_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/setting_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/student_review_selection.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/review_answers/presentation/widgets/app_drawer_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import '../widgets/app_drawer.dart';
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
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        setState(() {
          errorMessage = 'User not authenticated';
          isLoading = false;
        });
        return;
      }

      final quizId =
          widget.quizData[AppConstants.id] ;

      // ✅ Use the correct collection name
      final studentDoc =
          await FirebaseFirestore.instance
              .collection(
                AppConstants.studentCollection,
              ) // Changed from 'Student'
              .doc(userId)
              .collection(AppConstants.quizzessmall) // ✅ Changed from 'quizzes'
              .doc(quizId)
              .get(); // Fetch quiz metadata from Quizzes/{quizId}
      final quizDoc =
          await FirebaseFirestore.instance
              .collection(AppConstants.quizzesCollection)
              .doc(quizId)
              .get();

      Map<String, dynamic>? teacherData;
      if (quizDoc.exists) {
        final quizData = quizDoc.data();
        final teacherId = quizData?['teacherId'];

        // Fetch teacher details from teacher/{teacherId}
        if (teacherId != null && teacherId.toString().isNotEmpty) {
          final teacherDoc =
              await FirebaseFirestore.instance
                  .collection('teacher')
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
          errorMessage = 'Quiz details not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading quiz details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _deleteQuizResult() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final quizId = widget.quizData[AppConstants.id];

      // Show loading dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFF4FB3B7)),
            ),
      );

      // Delete the quiz result from Firebase
      await FirebaseFirestore.instance
          .collection(AppConstants.studentCollection)
          .doc(userId)
          .collection(AppConstants.quizzessmall)
          .doc(quizId)
          .delete();

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Navigate to BeforeQuizScreen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BeforeQuizScreen(quizId: quizId),
        ),
      );
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting quiz result: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
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
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${widget.quizData["title"]} Quiz",
            style: GoogleFonts.irishGrover(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),

        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4FB3B7)),
              )
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        _fetchAllQuizDetails();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4FB3B7),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DetailItem(
                      icon: IconParkOutline.list,
                      label: "Questions",
                      value: "${_getQuestionCount()}",
                    ),
                    const SizedBox(height: 16),
                    DetailItem(
                      icon: Lucide.alarm_clock,
                      label: "Time limit",
                      value: _getTimeLimit(),
                    ),
                    const SizedBox(height: 16),
                    DetailItem(
                      icon: Mdi.account_tie_outline,
                      label: "Creator",
                      value: _getCreator(),
                    ),
                    const SizedBox(height: 16),
                    DetailItem(
                      icon: Mdi.calendar_month,
                      label: "Completed on",
                      value: _formatDate(studentQuizDetails?['createdAt']),
                    ),
                    const SizedBox(height: 16),
                    DetailItem(
                      icon: Mdi.star_circle_outline,
                      label: "Score",
                      value: _calculateScore(),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // New: Chat button
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Chat with Teacher",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FB3B7),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final String? quizId =
                                widget.quizData[AppConstants.id];
                            String? teacherId;

                            // 1) حاول أولاً استخراج teacherId من quizMetadata (لو اتخزن بالفعل)
                            if (quizMetadata != null &&
                                quizMetadata!['teacherId'] != null) {
                              teacherId =
                                  quizMetadata!['teacherId']?.toString();
                            }

                            // 2) لو موجود في widget.quizData (نادر لكن نتأكد)
                            teacherId ??=
                                widget.quizData[AppConstants.teacherId];

                            final String studentUid =
                                FirebaseAuth.instance.currentUser!.uid;

                            if (quizId == null || quizId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Unable to open chat (missing quiz id).',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 3) لو مازال مفقود، نجيبه من collection "Quizzes"
                            if (teacherId == null || teacherId.isEmpty) {
                              // Show loading dialog
                              if (!mounted) return;
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (_) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF4FB3B7),
                                      ),
                                    ),
                              );

                              try {
                                final quizDoc =
                                    await FirebaseFirestore.instance
                                        .collection('Quizzes')
                                        .doc(quizId)
                                        .get();
                                if (quizDoc.exists) {
                                  final data = quizDoc.data();
                                  teacherId = data?['teacherId']?.toString();
                                }
                              } catch (e) {
                                // optional: print debug
                                debugPrint(
                                  'Failed to fetch quiz doc for teacherId: $e',
                                );
                              } finally {
                                if (mounted)
                                  Navigator.pop(context); // close loading
                              }
                            }

                            // 4) لو لسه مفيش teacherId نعرض رسالة خطأ
                            if (teacherId == null || teacherId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Unable to open chat (missing teacher id).',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 5) جاهز للانتقال — لف ChatScreen بـ BlocProvider (لو عندك ChatCubit موفّر عالميًا احذف BlocProvider)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider(
                                      create:
                                          (_) => ChatCubit(ChatRepository()),
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

                        const SizedBox(height: 12),

                        // Resolve Quiz button (existing)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FB3B7),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  backgroundColor: AppColors.bg,
                                  title: const Text(
                                    'Resolve Quiz',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'This will delete your current result and let you retake the quiz. Are you sure?',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(dialogContext),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF4FB3B7,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        _deleteQuizResult();
                                      },
                                      child: const Text(
                                        'Yes, Resolve',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Resolve Quiz",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // View Answers button (existing)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FB3B7),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            String studentUid =
                                FirebaseAuth.instance.currentUser!.uid;
                            final String teacherId =
                                widget.quizData[AppConstants.teacherId] ?? "";
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => StudentReviewSelectionScreen(
                                      quizId: widget.quizData[AppConstants.id]!,
                                      studentId: studentUid,
                                      quizTitle: widget.subject,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            "View Answers",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
    // Try to get from student quiz details first
    if (studentQuizDetails != null && studentQuizDetails!['total'] != null) {
      return studentQuizDetails!['total'];
    }

    // Try to get from quiz metadata
    if (quizMetadata != null) {
      if (quizMetadata!['question_count'] != null) {
        return quizMetadata!['question_count'];
      }
      // Check if questions array exists
      if (quizMetadata!['questions'] != null &&
          quizMetadata!['questions'] is List) {
        return (quizMetadata!['questions'] as List).length;
      }
    }

    return 0;
  }

  String _getTimeLimit() {
    // Try to get from quiz metadata
    if (quizMetadata != null && quizMetadata!['duration'] != null) {
      final duration = quizMetadata!['duration'];
      if (duration is String) {
        // If it's already a string like "120", convert to minutes
        final durationInt = int.tryParse(duration);
        if (durationInt != null) {
          return '${durationInt} Mins';
        }
        return duration.contains('Min') ? duration : '$duration Mins';
      } else if (duration is int) {
        return '$duration Mins';
      }
    }
    return '30 Mins'; // Default fallback
  }

  String _getCreator() {
    // Try to get from teacher details
    if (teacherDetails != null && teacherDetails!['fullName'] != null) {
      final fullName = teacherDetails!['fullName'];
      if (fullName is String && fullName.isNotEmpty) {
        return fullName;
      }
    }

    // Fallback to quiz metadata teacherId
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
