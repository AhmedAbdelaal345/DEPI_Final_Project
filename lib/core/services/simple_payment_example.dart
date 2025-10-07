// lib/core/services/simple_payment_example.dart
// مثال بسيط لكيفية استخدام نظام الدفع الجديد

import 'package:flutter/material.dart';
import 'payment_service.dart';

/// مثال 1: فتح صفحة الدفع من أي مكان في التطبيق
void exampleOpenPayment(BuildContext context) async {
  final paymentService = PaymentService();

  try {
    await paymentService.openPaymentPage(
      productName: 'Pro Membership',
      amount: 9.99,
    );

    // سيتم فتح صفحة الدفع في المتصفح
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete your payment in the browser'),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

/// مثال 2: التحقق من حالة Pro
void exampleCheckProStatus() async {
  final paymentService = PaymentService();

  bool isPro = await paymentService.checkProStatus();

  if (isPro) {
    print('User is PRO member!');
  } else {
    print('User is FREE member');
  }
}

/// مثال 3: تحديث حالة Pro بعد الدفع الناجح
/// (استخدم هذا في صفحة webhook أو بعد التأكد من الدفع يدوياً)
void exampleUpdateProStatus() async {
  final paymentService = PaymentService();

  try {
    await paymentService.updateProStatus(true);
    print('Pro status activated!');
  } catch (e) {
    print('Error updating pro status: $e');
  }
}

/// مثال 4: إضافة زر للترقية في أي صفحة
class UpgradeButton extends StatelessWidget {
  const UpgradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // الطريقة الأولى: فتح الدفع مباشرة
        exampleOpenPayment(context);

        // أو الطريقة الثانية: الانتقال لصفحة الترقية الكاملة
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const UpgradeToProPage(),
        //   ),
        // );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD700),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium),
          SizedBox(width: 8),
          Text('Upgrade to PRO'),
        ],
      ),
    );
  }
}

