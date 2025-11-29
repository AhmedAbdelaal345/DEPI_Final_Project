// features/home/data/repositories/history_repository.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/model/history_model.dart';
import 'package:depi_final_project/core/services/cache_service.dart';

class HistoryRepository {
  final CacheService cacheService;
  final FirebaseFirestore firestore;

  HistoryRepository({required this.cacheService, FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  String _cacheKey(String userId) => 'history_$userId';

  Future<List<QuizHistoryModel>> fetchStudentQuizzes(String userId) async {
    final snapshot = await firestore
        .collection(AppConstants.studentCollection)
        .doc(userId)
        .collection(AppConstants.quizzessmall)
        .get();

    final List<QuizHistoryModel> result = [];
    final List<Map<String, dynamic>> serial = [];
    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        result.add(QuizHistoryModel.fromFirestore(doc.id, data));
        serial.add({'quizId': doc.id, 'data': data});
      } catch (_) {}
    }

    try {
      await cacheService.saveString(_cacheKey(userId), jsonEncode(serial));
    } catch (_) {}

    return result;
  }

  Future<List<QuizHistoryModel>> getStudentQuizzes(String userId, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      try {
        final cached = await cacheService.getString(_cacheKey(userId));
        if (cached != null) {
          final List<dynamic> raw = jsonDecode(cached);
          return raw.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            final quizId = map['quizId']?.toString() ?? '';
            final data = Map<String, dynamic>.from(map['data'] ?? {});
            return QuizHistoryModel.fromFirestore(quizId, data);
          }).toList();
        }
      } catch (_) {}
    }
    return fetchStudentQuizzes(userId);
  }
}
