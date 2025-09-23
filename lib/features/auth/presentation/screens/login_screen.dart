import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/screens/forgotPasswordPage.dart';
import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/divider_with_text.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful!')),
                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
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
                    padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AuthHeader(
                            title: 'Login',
                            subtitle: 'Welcome  ! please enter your details',
                          ),

                           SizedBox(height: screenHeight * 0.05),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Enter your email',
                            prefixIcon: Icons.email_outlined,
                            errorText: state.emailError,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            errorText: state.passwordError,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: state.rememberMe,
                                onChanged: (value) {
                                  context.read<LoginCubit>().rememberMeChanged(
                                    value,
                                  );
                                },
                                fillColor: MaterialStateProperty.all(
                                  ColorApp.whiteColor,
                                ),
                                checkColor: ColorApp.backgroundColor,
                                activeColor: ColorApp.whiteColor,

                                side: const BorderSide(
                                  width: 2,
                                  color: ColorApp.splashTextColor,
                                ),
                              ),
                               Text(
                                'Remember this device',
                                style: TextStyle(
                                  color: ColorApp.whiteColor,
                                  fontSize: screenWidth * 0.028,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child:  Text(
                                  'Forget password',
                                  style: TextStyle(
                                    color: ColorApp.splashTextColor,
                                    fontSize: screenWidth * 0.028,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.04),
                          if (state.status == LoginStatus.loading)
                            const Center(child: CircularProgressIndicator())
                          else
                            CustomAuthButton(
                              text: 'Login',
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
                                } on FirebaseAuthException catch (e) {
                                  String errorMessage;

                                  switch (e.code) {
                                    case 'invalid-credential':
                                      errorMessage =
                                          "Invalid email or password. Please try again.";
                                      break;
                                    case 'user-not-found':
                                      errorMessage =
                                          "No user found for that email.";
                                      break;
                                    case 'wrong-password':
                                      errorMessage = "Wrong password provided.";
                                      break;
                                    case 'invalid-email':
                                      errorMessage = "Invalid email format.";
                                      break;
                                    case 'user-disabled':
                                      errorMessage =
                                          "This user account has been disabled.";
                                      break;
                                    case "network-request-failed":
                                      errorMessage =
                                          "Network error. Please check your internet connection and try again.";
                                    default:
                                      errorMessage =
                                          "Login failed: ${e.message}";
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
                           SizedBox(height: screenHeight * 0.05),
                          DividerWithText(text:' OR Login with '),
                          SizedBox(height: screenHeight * 0.05),

                          SocialLoginButtons(),

                          SizedBox(height: screenHeight * 0.04),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text:  TextSpan(
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Don’t have an account? ',
                                    style: TextStyle(
                                      color: ColorApp.whiteColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Create a new account',
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
