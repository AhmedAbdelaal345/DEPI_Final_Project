import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/color_app.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../screens/change_password_screan.dart';
import 'custom_auth_button.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    final state = context.watch<LoginCubit>().state;
    return Form(
        key: _formKey,
      child: Column(
        children: [
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
          SizedBox(height: screenHeight * 0.03),
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
          SizedBox(height: screenHeight * 0.01),

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
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChangepasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'Forget password',
                  style: TextStyle(
                    color: ColorApp.splashTextColor,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.055),
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
        ],
      ),
    );
  }
}
