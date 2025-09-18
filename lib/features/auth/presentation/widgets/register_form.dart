import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/constants/color_app.dart';
import '../cubit/register_details_cubit.dart';
import '../cubit/register_details_state.dart';
import 'custom_auth_button.dart';
import 'custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final state = context.watch<RegisterDetailsCubit>().state;
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _fullNameController,
              hintText: 'Full Name',
              prefixIcon: Icons.person_outline,
              errorText: state.fullNameError,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomTextField(
              controller: _emailController,
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              errorText: state.emailError,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[^@]+@[^@]+\.[^@]+',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
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
                  return 'Please confirm your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm your password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              errorText: state.confirmPasswordError,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.07),
            if (state.status == RegisterStatus.loading)
              const Center(child: CircularProgressIndicator())
            else
              CustomAuthButton(
                text: 'Register',

                onPressed: () async {
                  if (_formKey.currentState?.validate() != true) {
                    return;
                  }
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    context.read<RegisterDetailsCubit>().register(
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword:
                      _confirmPasswordController.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      Fluttertoast.showToast(
                        msg: "The password provided is too weak.",
                        backgroundColor: ColorApp.errorColor,
                        gravity: ToastGravity.BOTTOM,
                      );
                    } else if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(
                        msg: "email-already-in-use",
                        backgroundColor: ColorApp.errorColor,
                        gravity: ToastGravity.BOTTOM,
                      );

                      print(
                        'The account already exists for that email.',
                      );
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString(),
                      backgroundColor: ColorApp.errorColor,
                      gravity: ToastGravity.BOTTOM,
                    );
                    print(e);
                  }
                },
              ),
          ],
        ),
    );
  }
}
