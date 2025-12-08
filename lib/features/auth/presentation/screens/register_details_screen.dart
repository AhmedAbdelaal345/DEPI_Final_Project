import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class RegisterDetailsScreen extends StatefulWidget {
  RegisterDetailsScreen({super.key, required this.isTeacher});

  bool  isTeacher;

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isRegistering = false;

  String get collectionName =>
      widget.isTeacher
          ? AppConstants.teacherCollection
          : AppConstants.studentCollection;

  CollectionReference get users =>
      FirebaseFirestore.instance.collection(collectionName);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      await users.doc(credential.user?.uid).set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'phone': "+2${_phoneController.text.trim()}",
        if (widget.isTeacher) 'subject': _subjectController.text.trim(),
        'uid': credential.user?.uid,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).registrationSuccessful),
          duration: const Duration(seconds: 2),
          backgroundColor: ColorApp.successSnakBar,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = AppLocalizations.of(context).errorWeakPassword;
      } else if (e.code == 'email-already-in-use') {
        errorMessage = AppLocalizations.of(context).errorEmailInUse;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          }
        });
      } else {
        errorMessage = e.message ?? 'An authentication error occurred';
      }

      if (mounted) {
        Fluttertoast.showToast(
          msg: errorMessage,
          backgroundColor: ColorApp.errorColor,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Database error: ${e.message ?? e.toString()}',
          backgroundColor: ColorApp.errorColor,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Registration failed: ${e.toString()}',
          backgroundColor: ColorApp.errorColor,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorApp.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeightSpace2(screenHeight: screenHeight),

                  AuthHeader(
                    title: l10n.register,
                    subtitle: l10n.welcomeMessage,
                  ),
                  HeightSpace2(screenHeight: screenHeight),
                  CustomTextField(
                    controller: _fullNameController,
                    hintText: l10n.fullName,
                    prefixIcon: Icons.person_outline,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.enterYourFullName;
                      }
                      if (value.trim().length < 3) {
                        return 'Full name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: l10n.enterYourEmail,
                    prefixIcon: Icons.email_outlined,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterYourEmail;
                      }
                      if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value.trim())) {
                        return l10n.enterValidEmail;
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: l10n.enterYourPassword,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseConfirmPassword;
                      }
                      if (value.length < 6) {
                        return l10n.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: l10n.confirmYourPassword,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseConfirmPassword;
                      }
                      if (value != _passwordController.text) {
                        return l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: l10n.enterYourPhoneNumber,
                    prefixIcon: Icons.phone,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterPhoneNumber;
                      }
                      // if (!AppConstants.phoneRegExp.hasMatch(value.trim())) {
                      //   return l10n.enterValidPhoneNumber;
                      // }
                      return null;
                    },
                  ),
                  if (widget.isTeacher)
                    CustomTextField(
                      controller: _subjectController,
                      hintText: l10n.enterYourSubject,
                      prefixIcon: Icons.school,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterYourSubject;
                        }
                        if (value.trim().length < 2) {
                          return 'Subject must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                  HeightSpace2(screenHeight: screenHeight),
                  if (_isRegistering)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomAuthButton(
                      text: l10n.register,
                      onPressed: _handleRegistration,
                    ),
                  // SizedBox(height: screenHeight * 0.05),
                  // DividerWithText(text: l10n.orRegisterWith),
                  // SizedBox(height: screenHeight * 0.05),
                  // SocialLoginButtons(),
                  // SizedBox(height: screenHeight * 0.035),
                  AuthNavigationLink(
                    baseText: l10n.alreadyHaveAnAccount,
                    clickableText: l10n.login,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.isTeacher = !widget.isTeacher;
                      });
                    },
                    child: Text(
                      widget.isTeacher
                          ? "To Register as Student"
                          : "To Register as Teacher",
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeightSpace2 extends StatelessWidget {
  const HeightSpace2({
    super.key,
    required this.screenHeight,
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: screenHeight * 0.02);
  }
}
