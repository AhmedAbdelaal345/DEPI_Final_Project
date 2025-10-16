import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 👇 تأكد من وجود <Locale> هنا
class LocaleCubit extends Cubit<Locale> {

  // 👇 وتأكد من أن الـ super constructor يستدعي Locale
  LocaleCubit() : super(const Locale('en'));

  void changeLanguage(Locale newLocale) {
    emit(newLocale);
  }
}