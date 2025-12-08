// features/profile/presentation/screens/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/payment_card_preview.dart';
import '../widgets/payment_text_field.dart';
import '../utils/card_formatters.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(
        title: "Payment Details",
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProSubscriptionSuccess) {
            setState(() => _isProcessing = false);
            _showSuccessDialog();
          } else if (state is ProSubscriptionError) {
            setState(() => _isProcessing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Credit Card Preview
                PaymentCardPreview(
                  cardNumber: _cardNumberController.text,
                  cardHolder: _cardHolderController.text,
                  expiryDate: _expiryDateController.text,
                ),
                const SizedBox(height: 32),

                // Payment Form
                _buildPaymentForm(),
                const SizedBox(height: 32),

                // Payment Summary
                _buildPaymentSummary(),
                const SizedBox(height: 24),

                // Pay Button
                _isProcessing
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF5AC7C7),
                        ),
                      )
                    : CustomButton(
                        label: "Pay \$9.99",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _processPayment();
                          }
                        },
                      ),
                const SizedBox(height: 16),

                // Security Notice
                _buildSecurityNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Get current user
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // TODO: Here you would integrate with real payment gateway (Stripe/PayPal)
      // For now, we'll directly update the Pro status

      if (context.mounted) {
        context.read<ProfileCubit>().subscribeToPro(userId);
      }
    } else {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not logged in'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Information",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        PaymentTextField(
          controller: _cardNumberController,
          label: "Card Number",
          hint: "1234 5678 9012 3456",
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          maxLength: 19,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CardNumberFormatter(),
          ],
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 16),

        PaymentTextField(
          controller: _cardHolderController,
          label: "Card Holder Name",
          hint: "John Doe",
          icon: Icons.person_outline,
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: PaymentTextField(
                controller: _expiryDateController,
                label: "Expiry Date",
                hint: "MM/YY",
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                maxLength: 5,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ExpiryDateFormatter(),
                ],
                onChanged: (value) => setState(() {}),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PaymentTextField(
                controller: _cvvController,
                label: "CVV",
                hint: "123",
                icon: Icons.lock_outline,
                keyboardType: TextInputType.number,
                maxLength: 3,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF5AC7C7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Subscription Plan", "Pro Monthly"),
          const SizedBox(height: 12),
          _buildSummaryRow("Amount", "\$9.99"),
          const SizedBox(height: 12),
          _buildSummaryRow("Tax", "\$0.00"),
          const Divider(color: Color(0xFF5AC7C7), height: 24),
          _buildSummaryRow(
            "Total",
            "\$9.99",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white70,
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? const Color(0xFF5AC7C7) : Colors.white,
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNotice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(
          "Secure payment powered by Stripe",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF5AC7C7).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF5AC7C7),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Welcome to Pro! Enjoy unlimited access to all features.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: "Get Started",
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
