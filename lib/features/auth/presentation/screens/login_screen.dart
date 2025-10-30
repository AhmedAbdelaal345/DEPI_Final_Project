import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/core/services/auth_service.dart';
import 'package:depi_final_project/features/Teacher/wrapper_teacher_screen.dart';
import 'package:depi_final_project/features/auth/presentation/screens/forgotPasswordPage.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';

import 'package:depi_final_project/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "/login_page";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkUserTypeAndNavigate(String? uid) async {
    if (uid == null) return;

    try {
      // Check if user exists in Student collection
      DocumentSnapshot studentDoc =
          await FirebaseFirestore.instance.collection('Student').doc(uid).get();

      if (studentDoc.exists) {
        print('User is a Student');
        // Save login state
        await _authService.saveLoginState(userId: uid, userType: 'student');
        // Navigate to student home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WrapperPage()),
        );
        return;
      }

      DocumentSnapshot teacherDoc =
          await FirebaseFirestore.instance.collection('teacher').doc(uid).get();

      if (teacherDoc.exists) {
        print('User is a Teacher');
        // Save login state
        await _authService.saveLoginState(userId: uid, userType: 'teacher');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WrapperTeacherPage()),
        );
        return;
      }

      // If user not found in either collection
      Fluttertoast.showToast(
        msg: "User data not found. Please contact support.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Error checking user type: $e');
      Fluttertoast.showToast(
        msg: "Error retrieving user data. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: ColorApp.backgroundColor,
        body: SafeArea(
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.loginSuccessful)));
                // Remove this navigation as it will be handled by _checkUserTypeAndNavigate
              } else if (state.status == LoginStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.generalError ?? 'An error occurred'),
                  ),
                );
              }
            },
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.055,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AuthHeader(
                            title: l10n.login,
                            subtitle: l10n.welcomeMessage,
                          ),

                          SizedBox(height: screenHeight * 0.02),
                          CustomTextField(
                            controller: _emailController,
                            hintText: l10n.enterYourEmail,
                            prefixIcon: Icons.email_outlined,
                            errorText: state.emailError,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return l10n.pleaseEnterYourEmail;
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
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
                            errorText: state.passwordError,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return l10n.pleaseEnterPassword;
                              }
                              if (value.length < 6) {
                                return l10n.passwordTooShort;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Checkbox(
                              //   value: state.rememberMe,
                              //   onChanged: (value) {
                              //     context.read<LoginCubit>().rememberMeChanged(
                              //       value,
                              //     );
                              //   },
                              //   fillColor: MaterialStateProperty.all(
                              //     ColorApp.whiteColor,
                              //   ),
                              //   checkColor: ColorApp.backgroundColor,
                              //   activeColor: ColorApp.whiteColor,
                              //
                              //   side: const BorderSide(
                              //     width: 2,
                              //     color: ColorApp.splashTextColor,
                              //   ),
                              // ),
                              // Text(
                              //   l10n.rememberThisDevice,
                              //   style: TextStyle(
                              //     color: ColorApp.whiteColor,
                              //     fontSize: screenWidth * 0.028,
                              //     fontWeight: FontWeight.w400,
                              //   ),
                              // ),
                              // Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  l10n.forgotPassword,
                                  style: TextStyle(
                                    color: ColorApp.splashTextColor,
                                    fontSize: screenWidth * 0.028,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // SizedBox(height: screenHeight * 0.01),
                          if (state.status == LoginStatus.loading)
                            const Center(child: CircularProgressIndicator())
                          else
                            CustomAuthButton(
                              text: l10n.login,
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                  context.read<LoginCubit>().login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  print(
                                    'User logged in: ${credential.user?.email}',
                                  );

                                  // Check if user is Student or Teacher
                                  await _checkUserTypeAndNavigate(
                                    credential.user?.uid,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  String errorMessage;

                                  switch (e.code) {
                                    case 'invalid-credential':
                                      errorMessage =
                                          l10n.errorInvalidCredential;
                                      break;
                                    case 'user-not-found':
                                      errorMessage = l10n.errorUserNotFound;
                                      break;
                                    case 'wrong-password':
                                      errorMessage = l10n.errorWrongPassword;
                                      break;
                                    case 'invalid-email':
                                      errorMessage = l10n.errorInvalidEmail;
                                      break;
                                    case 'user-disabled':
                                      errorMessage = l10n.errorUserDisabled;
                                      break;
                                    case "network-request-failed":
                                      errorMessage =
                                          l10n.errorNetworkRequestFailed;
                                    default:
                                      errorMessage = l10n.errorLoginFailed(
                                        e.message ?? 'Unknown error',
                                      );
                                  }

                                  Fluttertoast.showToast(
                                    msg: errorMessage,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );

                                  print(
                                    'Firebase Auth Error: ${e.code} - ${e.message}',
                                  );
                                } catch (e) {
                                  print("Abdelaal: $e");
                                  Fluttertoast.showToast(
                                    msg:
                                        "An unexpected error occurred. Please try again later.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                            ),
                          // SizedBox(height: screenHeight * 0.05),
                          // DividerWithText(text: l10n.orLoginWith),
                          // SizedBox(height: screenHeight * 0.05),
                          //
                          // SocialLoginButtons(),

                          // SizedBox(height: screenHeight * 0.04),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: l10n.dontHaveAnAccount,
                                    style: TextStyle(
                                      color: ColorApp.whiteColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: l10n.createNewAccount,
                                    style: TextStyle(
                                      color: ColorApp.splashTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
