import 'package:depi_final_project/features/authentication/presentation/widgets/custom_button.dart';
import 'package:depi_final_project/features/authentication/presentation/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangepasswordScreen extends StatefulWidget {
  const ChangepasswordScreen({super.key});

  @override
  State<ChangepasswordScreen> createState() => _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      _emailController.text = currentUser.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;

      try {
        if (user == null) {
          _showSnackbar("No user is currently logged in.", Colors.red);
          return;
        }

        if (user.email != _emailController.text.trim()) {
          _showSnackbar(
            "Email does not match your registered email.",
            Colors.red,
          );
          return;
        }

        AuthCredential credential = EmailAuthProvider.credential(
          email: _emailController.text.trim(),
          password: _currentPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(_newPasswordController.text.trim());

        _showSnackbar("Password changed successfully!", Colors.green);
        _clearFields();

        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'wrong-password':
            message = 'The current password is incorrect.';
            break;
          case 'too-many-requests':
            message = 'Too many failed attempts. Try again later.';
            break;
          case 'requires-recent-login':
            message = 'Please log out and log back in to change your password.';
            break;
          case 'user-not-found':
            message = 'User not found with this email.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          case 'weak-password':
            message = 'The new password is too weak.';
            break;
          default:
            message = e.message ?? 'An unknown error occurred.';
        }
        _showSnackbar(message, Colors.red);
      } catch (e) {
        _showSnackbar('An unexpected error occurred.', Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmNewPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Change Your Password",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null &&
                          currentUser.email != value.trim()) {
                        return 'Email must match your registered email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _currentPasswordController,
                    hintText: 'Current Password',
                    isPassword: true,
                    isPasswordVisible: _isCurrentPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _newPasswordController,
                    hintText: 'New Password',
                    isPassword: true,
                    isPasswordVisible: _isNewPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (value == _currentPasswordController.text) {
                        return 'New password must be different from current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _confirmNewPasswordController,
                    hintText: 'Confirm New Password',
                    isPassword: true,
                    isPasswordVisible: _isConfirmNewPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isConfirmNewPasswordVisible =
                            !_isConfirmNewPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    borderRadius: BorderRadius.circular(18),

                    text:
                        _isLoading ? "Changing Password..." : "Change Password",
                    onPressed: () {
                      _isLoading ? null : _changePassword();
                    },
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
