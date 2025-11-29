// core/widgets/shared_components.dart
import 'package:flutter/material.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';

/// Small reusable loading indicator
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({super.key, this.size = 24.0, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.teal,
        strokeWidth: 2.5,
      ),
    );
  }
}

/// Error view with optional retry button
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const ErrorView({super.key, required this.message, this.onRetry, this.retryLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                child: Text(retryLabel ?? 'Retry'),
              )
            ]
          ],
        ),
      ),
    );
  }
}

/// Lightweight scaffold for forms/pages with uniform padding and scroll
class FormScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Color backgroundColor;

  const FormScaffold({super.key, required this.child, this.appBar, this.backgroundColor = AppColors.bg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
