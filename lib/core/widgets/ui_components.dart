// core/widgets/ui_components.dart
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 48,
  });

  Color _background(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.secondary:
        return Colors.white24;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.primary:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _foreground(BuildContext context) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _background(context);
    final fg = _foreground(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: variant == AppButtonVariant.ghost ? 0 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white)) : child,
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String?>? onSaved;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onSaved,
  });

  InputBorder get _border => OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
  onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white10,
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
        errorBorder: _border.copyWith(borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final Color? color;

  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(12), this.elevation = 2, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: padding, child: child),
    );
  }
}

class LoadingSpinner extends StatelessWidget {
  final double size;

  const LoadingSpinner({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CircularProgressIndicator(strokeWidth: 2.4));
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessage({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(message, style: const TextStyle(color: Colors.redAccent)),
      if (onRetry != null) ...[
        const SizedBox(height: 8),
        AppButton(onPressed: onRetry, child: const Text('Retry'), variant: AppButtonVariant.secondary)
      ]
    ]);
  }
}

class AppDialog {
  static Future<T?> show<T>(BuildContext context, {required String title, required Widget content, List<Widget>? actions}) {
    return showDialog<T>(
      context: context,
      builder: (c) => AlertDialog(title: Text(title), content: content, actions: actions),
    );
  }
}
