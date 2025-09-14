import 'package:depi_final_project/features/authentication/presentation/screens/changePassword_screen.dart';
import 'package:depi_final_project/features/home/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'register_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_navigation_text.dart';
import '../widgets/auth_screen_title.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                const AuthScreenTitle(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to your account',
                ),
                const SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: !_isPasswordVisible,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangepasswordScreen(),
                      ),
                    );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF2196F3), fontSize: 14),
                    ),
                  ),
                ),
                // const SizedBox(height: 24),
                CustomButton(
                  text: 'Login',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Login successful!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen(
                                  userName: credential.user!.email!.trim(),
                                ),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        String errorMessage;

                        switch (e.code) {
                          case 'invalid-credential':
                            errorMessage =
                                "Invalid email or password. Please try again.";
                            break;
                          case 'user-not-found':
                            errorMessage = "No user found for that email.";
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
                            errorMessage = "Login failed: ${e.message}";
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

                        print('Firebase Auth Error: ${e.code} - ${e.message}');
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
                    }
                  },
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  borderRadius: BorderRadius.circular(18),
                ),
                const SizedBox(height: 20),
                AuthNavigationText(
                  normalText: 'Don\'t have an account? ',
                  clickableText: 'Sign Up',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccountScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
