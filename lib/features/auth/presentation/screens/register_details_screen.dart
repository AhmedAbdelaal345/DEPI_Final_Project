import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/login_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/register_details_cubit.dart';
import '../cubit/register_details_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/divider_with_text.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_icon_button.dart';

class RegisterDetailsScreen extends StatefulWidget {
  RegisterDetailsScreen({super.key, required this.isTeacher});

  bool isTeacher;

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
  String get collectionName => widget.isTeacher ? 'teacher' : 'Student';

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => RegisterDetailsCubit(),
      child: Scaffold(
        backgroundColor: ColorApp.backgroundColor,

        body: BlocListener<RegisterDetailsCubit, RegisterDetailsState>(
          listener: (context, state) {
            if (state.status == RegisterStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration Successful!'),
                  duration: Duration(seconds: 1),
                  backgroundColor: ColorApp.successSnakBar,
                ),
              );
              // After successful registration, navigate to the login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else if (state.status == RegisterStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.generalError ?? 'An error occurred'),
                  duration: Duration(seconds: 2),
                  backgroundColor: ColorApp.errorColor,
                ),
              );
            }
          },
          child: BlocBuilder<RegisterDetailsCubit, RegisterDetailsState>(
            builder: (context, state) {
              return SafeArea(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.065,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AuthHeader(
                            title: 'Register',
                            subtitle: 'Welcome  ! please enter your details',
                          ),
                          SizedBox(height: screenHeight * 0.05),
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
                
                          CustomTextField(
                            controller: _phoneController,
                            hintText: "Enter your Phone Number",
                            prefixIcon: Icons.phone,
                            errorText: state.phoneError,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!AppConstants.phoneRegExp.hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                            },
                          ),
                          if (widget.isTeacher)
                            CustomTextField(
                              controller: _subjectController,
                              hintText: "Enter your Subject",
                              prefixIcon: Icons.school,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Subject';
                                }
                                return null;
                              },
                            ),
                          SizedBox(height: screenHeight * 0.04),
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
                                    isTeacher:
                                        await BlocProvider.of<LoginCubit>(
                                          context,
                                        ).isTeacher(),
                                  );
                                  await users.doc(credential.user?.uid).set({
                                    'fullName': _fullNameController.text,
                                    'email': _emailController.text,
                                    'password': _passwordController.text,
                                    'phone': _phoneController.text,
                                    if (widget.isTeacher)
                                      'subject': _subjectController.text,
                                    'uid': credential.user?.uid,
                                  });
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
                                } on FirebaseException catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    backgroundColor: ColorApp.errorColor,
                                    gravity: ToastGravity.BOTTOM,
                                  );
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
                          SizedBox(height: screenHeight * 0.05),
                          DividerWithText(text: ' OR Register with '),
                
                          SizedBox(height: screenHeight * 0.05),
                
                          SocialLoginButtons(),
                
                          SizedBox(height: screenHeight * 0.035),
                
                          AuthNavigationLink(
                            baseText: 'Already have an account? ',
                            clickableText: 'Login',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight*0.01,),
                          InkWell(
                            onTap: () {
                              widget.isTeacher = !widget.isTeacher;
                              setState(() {
                                
                              });
                            },
                            child:
                                widget.isTeacher == true
                                    ? Text(
                                      "To Register as Student",
                                      style: TextStyle(
                                        color: AppColors.teal,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    )
                                    : Text(
                                      "To Register as Teacher",
                                      style: TextStyle(
                                        color: AppColors.teal,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
