import 'package:depi_final_project/features/home/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_navigation_text.dart';
import '../widgets/auth_screen_title.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                const SizedBox(height: 15),
                const AuthScreenTitle(title: 'Create Account'),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: 'Full Name',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: !_isConfirmPasswordVisible,
                        isPassword: true,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Register',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Account created successfully!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
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
                        if (e.code == 'weak-password') {
                          Fluttertoast.showToast(
                            msg: "The password provided is too weak.",
                            backgroundColor: Colors.red,
                            fontSize: 18,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                          );
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(
                            msg: "The account already exists for that email.",
                            backgroundColor: Colors.red,
                            fontSize: 18,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                          );
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
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
                  normalText: 'Already have an account? ',
                  clickableText: 'Login',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
