import 'dart:developer';

import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/splash/presentation/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<Widget> {
  AuthCubit() : super(Container());
  void userHaveLogin() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        emit((SplashScreen()));
        log("User is currently signed out!");
      } else {
        emit(WrapperPage());
        log("User is currently signed In!");
      }
    });
  }
}
