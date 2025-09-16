import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/register_details_cubit.dart';
import '../cubit/register_details_state.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_icon_button.dart';

class RegisterDetailsScreen extends StatefulWidget {
  const RegisterDetailsScreen({super.key});

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
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
    return BlocProvider(
      create: (context) => RegisterDetailsCubit(),
      child: Scaffold(
        backgroundColor: ColorApp.backgroundColor,
        body: SafeArea(
          child: BlocListener<RegisterDetailsCubit, RegisterDetailsState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration Successful!')),
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
                  ),
                );
              }
            },
            child: BlocBuilder<RegisterDetailsCubit, RegisterDetailsState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Register',
                            style: GoogleFonts.irishGrover(
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                              color: ColorApp.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'Welcome  ! please enter your details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorApp.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 45),
                          CustomTextField(
                            controller: _fullNameController,
                            hintText: 'Full Name',
                            prefixIcon: Icons.person_outline,
                            errorText: state.fullNameError,
                            validator: (String ?value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                            },
                          ),
                          const SizedBox(height: 27),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Enter your email',
                            prefixIcon: Icons.email_outlined,
                            errorText: state.emailError,
                            validator: (String ?value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                            },
                          ),
                          const SizedBox(height: 27),
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
                          const SizedBox(height: 27),
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
                          const SizedBox(height: 64),
                          if (state.status == RegisterStatus.loading)
                            const Center(child: CircularProgressIndicator())
                          else
                            CustomAuthButton(
                              text: 'Register',
                  
                              onPressed: () async {
                                if(_formKey.currentState?.validate() != true){
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
                          const SizedBox(height: 44),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: ColorApp.whiteColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3.0,
                                ),
                                child: Text(
                                  'OR Register with',
                                  style: GoogleFonts.irishGrover(
                                    color: ColorApp.whiteColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: ColorApp.whiteColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 44),
                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialIconButton(
                                iconPath: AppConstants.googleLogo,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 20),
                              SocialIconButton(
                                iconPath: AppConstants.facebookLogo,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 20),
                              SocialIconButton(
                                iconPath: AppConstants.appleLogo,
                                onPressed: () {},
                              ),
                            ],
                          ),
                  
                          const SizedBox(height: 48),
                  
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(color: ColorApp.whiteColor),
                                  ),
                                  TextSpan(
                                    text: 'Login',
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
