// features/profile/data/models/user_profile_model.dart
class UserProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final bool isPro;
  final DateTime? proSubscriptionDate;
  final DateTime? proExpiryDate;
  final int quizzesTaken;
  final int subjects;
  final int averageScore;

  UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImageUrl,
    this.isPro = false,
    this.proSubscriptionDate,
    this.proExpiryDate,
    this.quizzesTaken = 0,
    this.subjects = 0,
    this.averageScore = 0,
  });

  // Convert from Firebase document
  factory UserProfileModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfileModel(
      uid: uid,
      fullName: data['fullName'] ?? data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      profileImageUrl: data['profileImageUrl'],
      isPro: data['isPro'] ?? false,
      proSubscriptionDate: data['proSubscriptionDate'] != null
          ? DateTime.parse(data['proSubscriptionDate'])
          : null,
      proExpiryDate: data['proExpiryDate'] != null
          ? DateTime.parse(data['proExpiryDate'])
          : null,
      quizzesTaken: data['quizzesTaken'] ?? 0,
      subjects: data['subjects'] ?? 0,
      averageScore: data['averageScore'] ?? 0,
    );
  }

  // Convert to Firebase document
  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'isPro': isPro,
      'proSubscriptionDate': proSubscriptionDate?.toIso8601String(),
      'proExpiryDate': proExpiryDate?.toIso8601String(),
      'quizzesTaken': quizzesTaken,
      'subjects': subjects,
      'averageScore': averageScore,
    };
  }

  // CopyWith method for updates
  UserProfileModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    bool? isPro,
    DateTime? proSubscriptionDate,
    DateTime? proExpiryDate,
    int? quizzesTaken,
    int? subjects,
    int? averageScore,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPro: isPro ?? this.isPro,
      proSubscriptionDate: proSubscriptionDate ?? this.proSubscriptionDate,
      proExpiryDate: proExpiryDate ?? this.proExpiryDate,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      subjects: subjects ?? this.subjects,
      averageScore: averageScore ?? this.averageScore,
    );
  }

  // Check if Pro subscription is active
  bool get isProActive {
    if (!isPro) return false;
    if (proExpiryDate == null) return true; // No expiry means lifetime
    return DateTime.now().isBefore(proExpiryDate!);
  }
}

