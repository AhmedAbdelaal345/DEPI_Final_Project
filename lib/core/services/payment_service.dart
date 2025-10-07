// lib/core/services/payment_service.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stripe Keys
  static const String stripePublishableKey =
      'pk_test_51SDRaLPxDRIjAZJWt1zds0gAdVU28BYrSV4IPY50MYSJN8NCqQsVpv5cy58UzKrz8NpuAv2o1yWLJvWh3ni3MiPz00g0Tm4bka';

  // رابط Stripe للدفع - الرابط الكامل الصحيح
  static const String stripePaymentLinkPro =
      'https://buy.stripe.com/test_9B6eVf7Oiflz77b4qq6EU00';

  /// فتح صفحة الدفع في المتصفح
  Future<void> openPaymentPage({
    required String productName,
    required double amount,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      // إنشاء سجل للدفع المعلق في Firestore
      await _firestore.collection('pending_payments').doc(user.uid).set({
        'userId': user.uid,
        'email': user.email,
        'productName': productName,
        'amount': amount,
        'currency': 'USD',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // فتح رابط الدفع في المتصفح
      final Uri paymentUrl = Uri.parse(stripePaymentLinkPro);

      if (await canLaunchUrl(paymentUrl)) {
        await launchUrl(
          paymentUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('لا يمكن فتح صفحة الدفع');
      }
    } catch (e) {
      throw Exception('فشل فتح صفحة الدفع: $e');
    }
  }

  /// حل بديل: تفعيل Pro يدوياً للتجربة (استخدم هذا في مرحلة التطوير فقط!)
  Future<void> activateProForTesting() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'isPro': true,
        'proActivatedAt': FieldValue.serverTimestamp(),
        'email': user.email,
      }, SetOptions(merge: true));

      // حذف أي سجل دفع معلق
      try {
        await _firestore.collection('pending_payments').doc(user.uid).delete();
      } catch (e) {
        // تجاهل الخطأ إذا لم يكن هناك سجل
      }
    } catch (e) {
      throw Exception('فشل تفعيل Pro: $e');
    }
  }

  /// إلغاء Pro
  Future<void> deactivatePro() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      await _firestore.collection('users').doc(user.uid).update({
        'isPro': false,
        'proDeactivatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('فشل إلغاء Pro: $e');
    }
  }

  /// التحقق من حالة الاشتراك
  Future<bool> checkProStatus() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return false;

      final data = doc.data();
      return data?['isPro'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Stream للاستماع لتغييرات حالة Pro
  Stream<bool> watchProStatus() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(false);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return false;
      final data = snapshot.data();
      return data?['isPro'] ?? false;
    });
  }

  /// تحديث حالة Pro بعد الدفع الناجح
  Future<void> updateProStatus(bool isPro) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'isPro': isPro,
        'proActivatedAt': FieldValue.serverTimestamp(),
        'email': user.email,
      }, SetOptions(merge: true));

      // حذف سجل الدفع المعلق
      try {
        await _firestore.collection('pending_payments').doc(user.uid).delete();
      } catch (e) {
        // تجاهل الخطأ إذا لم يكن هناك سجل
      }
    } catch (e) {
      throw Exception('فشل تحديث حالة Pro: $e');
    }
  }
}
